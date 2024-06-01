/**
 * @file Launcher.m
 * @brief Kayte for Xcode Launcher
 *
 * Kayte for Xcode is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 * Kayte for Xcode is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 *
 * This launcher program responds to open and print document AppleEvents
 * by passing them to Xcode.
 */


#include <ApplicationServices/ApplicationServices.h>
#include <Carbon/Carbon.h>
#include <stdlib.h>
#include <stdbool.h>

/**
 * @brief Extract files from event and launch them using launchOptions.
 *
 * @param event The AppleEvent containing the files to open.
 * @param launchOption The launch options for the application.
 */
void openFromAppleEvent(const AppleEvent *event, LSLaunchFlags launchOption) {
    AEDescList documentList;
    OSErr err = AEGetParamDesc(event, keyDirectObject, typeAEList, &documentList);
    if (err != noErr) return;

    long documentCount;
    err = AECountItems(&documentList, &documentCount);
    if (err == noErr) {
        FSRef *documents = (FSRef *)malloc(sizeof(FSRef) * documentCount);
        if (!documents) return;

        for (long i = 0; i < documentCount; i++) {
            AEKeyword keyword;
            DescType returnedType;
            Size actualSize;
            err = AEGetNthPtr(&documentList, i + 1, typeFSRef, &keyword,
                              &returnedType, (Ptr)&documents[i], sizeof(FSRef), &actualSize);
            if (err != noErr) break;
        }
        if (err == noErr) {
            CFURLRef appURL = NULL;
            err = LSCopyApplicationURLsForBundleIdentifier(kLSUnknownCreator, CFSTR("com.apple.xcode"));

            if (err == noErr) {
                for (long i = 0; i < documentCount; i++) {
                    UInt8 fsPath[PATH_MAX];
                    if (FSRefMakePath(&documents[i], fsPath, sizeof(fsPath)) == noErr) {
                        CFURLRef fileURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, fsPath, strlen((char*)fsPath), false);
                        if (fileURL) {
                            CFArrayRef filesToOpen = CFArrayCreate(kCFAllocatorDefault, (const void**)&fileURL, 1, &kCFTypeArrayCallBacks);
                            if (filesToOpen) {
                                LSLaunchURLSpec launchSpec;
                                launchSpec.appURL = appURL;
                                launchSpec.itemURLs = filesToOpen;
                                launchSpec.passThruParams = NULL;
                                launchSpec.launchFlags = launchOption;
                                launchSpec.asyncRefCon = NULL;
                                LSOpenFromURLSpec(&launchSpec, NULL);
                                CFRelease(filesToOpen);
                            }
                            CFRelease(fileURL);
                        }
                    }
                }
                CFRelease(appURL);
            }
        }

        if (documents) free(documents);
    }
    AEDisposeDesc(&documentList);
}

/**
 * @brief Handle open document AppleEvents.
 *
 * @param event The AppleEvent containing the open document request.
 * @param reply The AppleEvent for the reply.
 * @param handlerRefcon Reference constant for the handler.
 * @return OSErr noErr if successful.
 */
OSErr handleOpenDocument(const AppleEvent *event, AppleEvent *reply, long handlerRefcon) {
    openFromAppleEvent(event, kLSLaunchDefaults);
    return noErr;
}

/**
 * @brief Handle print document AppleEvents.
 *
 * @param event The AppleEvent containing the print document request.
 * @param reply The AppleEvent for the reply.
 * @param handlerRefcon Reference constant for the handler.
 * @return OSErr noErr if successful.
 */
OSErr handlePrintDocument(const AppleEvent *event, AppleEvent *reply, long handlerRefcon) {
    openFromAppleEvent(event, kLSLaunchAndPrint);
    return noErr;
}

/**
 * @brief Alternative quit function to perform cleanup before quitting.
 */
void alternativeQuit(void) {
    // Perform any cleanup or other tasks needed before quitting
    exit(0);
}

/**
 * @brief Event processing loop using CFRunLoopRunInMode.
 */
void processEvents(void) {
    EventRecord event;
    while (true) {
        CFStringRef mode = kCFRunLoopDefaultMode;
        CFTimeInterval interval = 30.0;
        Boolean result = CFRunLoopRunInMode(mode, interval, true);
        if (result == kCFRunLoopRunHandledSource) {
            if (event.what == kHighLevelEvent) {
                OSErr err = AEProcessAppleEvent(&event);
                if (err != noErr) {
                    // Handle error if needed
                }
            }
        }
    }
}

/**
 * @brief Main function to install Apple Event handlers and process events.
 *
 * @param argc Argument count.
 * @param argv Argument vector.
 * @return int Exit status.
 */
int main(int argc, char *argv[]) {
    // Install Apple Event handler
    AEInstallEventHandler(kCoreEventClass, kAEOpenDocuments,
                          (AEEventHandlerUPP)handleOpenDocument, 0, false);
    AEInstallEventHandler(kCoreEventClass, kAEPrintDocuments,
                          (AEEventHandlerUPP)handlePrintDocument, 0, false);

    {
        // Installing quit timer after some fraction of a second
        EventLoopTimerUPP timerUPP = NewEventLoopTimerUPP((EventLoopTimerProcPtr)alternativeQuit);
        EventLoopTimerRef theTimer;

        InstallEventLoopTimer(GetMainEventLoop(), 0.1, 0.1,
                              timerUPP, NULL, &theTimer);
    }

    processEvents();

    return 0;
}
