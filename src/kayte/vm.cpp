#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <zlib.h>
#include <zip.h>

// Function to list the contents of a pk3 file
void list_pk3_contents(const std::string& pk3_path) {
    // Open the pk3 (zip) archive
    int err = 0;
    zip *archive = zip_open(pk3_path.c_str(), 0, &err);

    if (!archive) {
        std::cerr << "Failed to open PK3 file: " << pk3_path << std::endl;
        return;
    }

    zip_int64_t num_entries = zip_get_num_entries(archive, 0);
    std::cout << "PK3 file contains " << num_entries << " files:\n";

    for (zip_uint64_t i = 0; i < num_entries; ++i) {
        const char *name = zip_get_name(archive, i, 0);
        if (name == nullptr) {
            std::cerr << "Failed to get file name for file " << i << std::endl;
            continue;
        }
        std::cout << name << "\n";
    }

    zip_close(archive);
}
