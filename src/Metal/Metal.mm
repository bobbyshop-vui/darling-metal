// SPDX-FileCopyrightText: 2026 Darling Developers
// SPDX-License-Identifier: MPL-2.0

#import <Metal/Metal.h>
#if DARLING_METAL_ENABLED
#include <indium/indium.hpp>
#endif
#import <Metal/MTLDeviceInternal.h>
#import <Metal/stubs.h>

#if DARLING_METAL_ENABLED

#include <stdio.h>
#include <string.h>
extern "C" {
// Host Mesa creates its shader cache under $MESA_SHADER_CACHE_DIR, $XDG_CACHE_HOME or
// $HOME/.cache. Inside Darling the host environment's HOME is the macOS one (/Users/...), which
// does not exist on the host, so Mesa would print "Failed to create /Users for shader cache".
// Point Mesa at the host user's real cache directory, or disable the cache if there is none.
#include <elfcalls.h>
extern const struct elf_calls* _elfcalls;

static void darlingPrepareMesaShaderCache(void) {
	const struct elf_calls* ec = _elfcalls;
	if (!ec || !ec->dlsym_fatal) return;
	char* (*h_getenv)(const char*) = (char* (*)(const char*)) ec->dlsym(NULL, "getenv");
	int (*h_setenv)(const char*, const char*, int) = (int (*)(const char*, const char*, int)) ec->dlsym(NULL, "setenv");
	int (*h_access)(const char*, int) = (int (*)(const char*, int)) ec->dlsym(NULL, "access");
	unsigned (*h_getuid)(void) = (unsigned (*)(void)) ec->dlsym(NULL, "getuid");
	void* (*h_getpwuid)(unsigned) = (void* (*)(unsigned)) ec->dlsym(NULL, "getpwuid");
	if (!h_getenv || !h_setenv || !h_access) return;
	if (h_getenv("MESA_SHADER_CACHE_DIR") || h_getenv("XDG_CACHE_HOME") || h_getenv("MESA_SHADER_CACHE_DISABLE")) return;

	char path[1024];
	const char* home = NULL;
	if (h_getpwuid && h_getuid) {
		// struct passwd: pw_name, pw_passwd, pw_uid, pw_gid, pw_gecos, pw_dir, ...
		void* pw = h_getpwuid(h_getuid());
		if (pw) home = *(const char**) ((char*) pw + 3 * sizeof(void*) + 2 * sizeof(unsigned)); // pw_dir: 32 on x86_64, 20 on i386
	}
	if (home && home[0] == '/' && strlen(home) < sizeof(path) - 8) {
		snprintf(path, sizeof(path), "%s/.cache", home);
		if (h_access(path, 2 /* W_OK */) == 0) {
			h_setenv("XDG_CACHE_HOME", path, 0);
			return;
		}
	}
	h_setenv("MESA_SHADER_CACHE_DISABLE", "true", 0);
}
}

// TODO: add some extension here that MetalKit needs.
//
// because MetalKit gets loaded after we do, it has no way to tell us what extensions it needs.
// so, we have to hardcode it here and always require those extensions, even if we don't actually
// use MetalKit. TODO: find some way to avoid hardcoding these extensions.
static const char* additionalExtensions[] = {
	// we don't render to these directly; see CAMetalDrawable.mm (in Cocotron's QuartzCore) for more details
	//"VK_KHR_xlib_surface",
	//"VK_KHR_surface",
	//"VK_KHR_swapchain",
};

__attribute__((constructor))
static void initMetal(void) {
	darlingPrepareMesaShaderCache();

	bool enableValidation = false;

	if (getenv("METAL_INDIUM_VALIDATION") || getenv("DARLING_METAL_VALIDATION")) {
		enableValidation = true;
	}

	Indium::init(additionalExtensions, sizeof(additionalExtensions) / sizeof(*additionalExtensions), enableValidation);
};

__attribute__((destructor))
static void finitMetal(void) {
	MTLDeviceDestroyAll();
	Indium::finit();
};

#endif
