// D for Xcode Launcher
// Copyright (c) 2007-2010  Michel Fortin
//
// D for Xcode is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option)
// any later version.
//
// D for Xcode is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License
// along with D for Xcode; if not, write to the Free Software Foundation,
// Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA.

// This launcher program responds to open and print documents AppleEvents
// by passing them to Xcode.

#include <ApplicationServices/ApplicationServices.h>
#include <Carbon/Carbon.h>
#include <stdlib.h>
#include <stdbool.h>

/** Extract files from event and launch them using launchOptions. */
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
            LSApplicationParameters params;
            FSRef app;

            err = LSFindApplicationForInfo(kLSUnknownCreator, CFSTR("com.apple.xcode"), NULL, &app, NULL);
            
            if (err == noErr) {
                params.version = 0;
                params.flags = launchOption;
                params.application = &app;
                params.asyncLaunchRefCon = NULL;
                params.environment = NULL;
                params.argv = NULL;
                params.initialEvent = NULL;
            
                LSOpenItemsWithRole(documents, documentCount,
                    kLSRolesAll, NULL, &params, NULL, NULL);
            }
        }
            
        if (documents) free(documents);
    }
    AEDisposeDesc(&documentList);
}

// Event handler functions.

OSErr handleOpenDocument(const AppleEvent *event, AppleEvent *reply, long handlerRefcon) {
    openFromAppleEvent(event, kLSLaunchDefaults);
    return noErr;
}

OSErr handlePrintDocument(const AppleEvent *event, AppleEvent *reply, long handlerRefcon) {
    openFromAppleEvent(event, kLSLaunchAndPrint);
    return noErr;
}

// Alternative quit function
void alternativeQuit() {
    // Perform any cleanup or other tasks needed before quitting
    exit(0);
}

// Event processing loop using CFRunLoopRunInMode
void processEvents() {
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
