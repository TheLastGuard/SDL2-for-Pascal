unit sdl2_ttf;

{*
  SDL_ttf:  A companion library to SDL for working with TrueType (tm) fonts
  Copyright (C) 2001-2013 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgement in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*}

{* This library is a wrapper around the excellent FreeType 2.0 library,
   available at:
    http://www.freetype.org/
*}

interface

{$I jedi.inc}

uses
  {$IFDEF FPC}
  ctypes,
  {$ENDIF}
  SDL2;

{$I ctypes.inc}

const
  {$IFDEF WINDOWS}
    TTF_LibName = 'SDL2_ttf.dll';
  {$ENDIF}

  {$IFDEF UNIX}
    {$IFDEF DARWIN}
      TTF_LibName = 'libSDL2_tff.dylib';
    {$ELSE}
      {$IFDEF FPC}
        TTF_LibName = 'libSDL2_ttf.so';
      {$ELSE}
        TTF_LibName = 'libSDL2_ttf.so.0';
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  {$IFDEF MACOS}
    TTF_LibName = 'SDL2_ttf';
    {$IFDEF FPC}
      {$linklib libSDL2_ttf}
    {$ENDIF}
  {$ENDIF}

{* Set up for C function definitions, even when using C++ *}

{* Printable format: "%d.%d.%d", MAJOR, MINOR, PATCHLEVEL *}
const
  SDL_TTF_MAJOR_VERSION = 2;
  SDL_TTF_MINOR_VERSION = 0;
  SDL_TTF_PATCHLEVEL    = 18;

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);

{* Backwards compatibility *}
const
  TTF_MAJOR_VERSION = SDL_TTF_MAJOR_VERSION;
  TTF_MINOR_VERSION = SDL_TTF_MINOR_VERSION;
  TTF_PATCHLEVEL    = SDL_TTF_PATCHLEVEL;

{*
 * Query the version of SDL_ttf that the program is linked against.
 *
 * This function gets the version of the dynamically linked SDL_ttf library.
 * This is separate from the SDL_TTF_VERSION() macro, which tells you what
 * version of the SDL_ttf headers you compiled against.
 *
 * This returns static internal data; do not free or modify it!
 *
 * \returns a pointer to the version information.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
(* Const before type ignored *)
function TTF_Linked_Version: PSDL_version; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Linked_Version' {$ENDIF} {$ENDIF};

{*
 * Query the version of the FreeType library in use.
 *
 * TTF_Init() should be called before calling this function.
 *
 * \param major to be filled in with the major version number. Can be nil.
 * \param minor to be filled in with the minor version number. Can be nil.
 * \param patch to be filled in with the param version number. Can be nil.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_Init
  }
procedure TTF_GetFreeTypeVersion(major: pcint; minor: pcint; patch: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFreeTypeVersion' {$ENDIF} {$ENDIF};

{*
 * Query the version of the HarfBuzz library in use.
 *
 * If HarfBuzz is not available, the version reported is 0.0.0.
 *
 * \param major to be filled in with the major version number. Can be nil.
 * \param minor to be filled in with the minor version number. Can be nil.
 * \param patch to be filled in with the param version number. Can be nil.
 *
 * \since This function is available since SDL_ttf 2.0.18.
  }
procedure TTF_GetHarfBuzzVersion(major: pcint; minor: pcint; patch: pcint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetHarfBuzzVersion' {$ENDIF} {$ENDIF};

{*
 * ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark)
  }
const
  UNICODE_BOM_NATIVE  = $FEFF;
  UNICODE_BOM_SWAPPED = $FFFE;

{*
 * Tell SDL_ttf whether UNICODE text is generally byteswapped.
 *
 * A UNICODE BOM character in a string will override this setting for the
 * remainder of that string.
 *
 * \param swapped boolean to indicate whether text is byteswapped
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
procedure TTF_ByteSwappedUNICODE(swapped: TSDL_bool); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_ByteSwappedUNICODE' {$ENDIF} {$ENDIF};

{* The internal structure containing font information *}
type
  PTTF_Font = ^TTTF_Font;
  TTTF_Font = record  end; //todo?

{*
 * Initialize SDL_ttf.
 *
 * You must successfully call this function before it is safe to call any
 * other function in this library, with one exception: a human-readable error
 * message can be retrieved from TTF_GetError() if this function fails.
 *
 * SDL must be initialized before calls to functions in this library, because
 * this library uses utility functions from the SDL library.
 *
 * It is safe to call this more than once; the library keeps a counter of init
 * calls, and decrements it on each call to TTF_Quit, so you must pair your
 * init and quit calls.
 *
 * \returns 0 on success, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_Quit
  }
function TTF_Init(): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Init' {$ENDIF} {$ENDIF};

{*
 * Create a font from a file, using a specified point size.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param file path to font file.
 * \param ptsize point size to use for the newly-opened font.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFont(file: PAnsiChar; ptsize: cint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFont' {$ENDIF} {$ENDIF};

{*
 * Create a font from a file, using a specified face index.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * Some fonts have multiple "faces" included. The index specifies which face
 * to use from the font file. Font files with only one face should specify
 * zero for the index.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param file path to font file.
 * \param ptsize point size to use for the newly-opened font.
 * \param index index of the face in the font file.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontIndex(file: PAnsiChar; ptsize: cint; index: clong): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndex' {$ENDIF} {$ENDIF};

{*
 * Create a font from an SDL_RWops, using a specified point size.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * If `freesrc` is non-zero, the RWops will be closed before returning,
 * whether this function succeeds or not. SDL_ttf reads everything it needs
 * from the RWops during this call in any case.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param src an SDL_RWops to provide a font file's data.
 * \param freesrc non-zero to close the RWops before returning, zero to leave
 *                it open.
 * \param ptsize point size to use for the newly-opened font.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontRW(src: PSDL_RWops; freesrc: cint; ptsize: cint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontRW' {$ENDIF} {$ENDIF};

{*
 * Create a font from an SDL_RWops, using a specified face index.
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * If `freesrc` is non-zero, the RWops will be closed before returning,
 * whether this function succeeds or not. SDL_ttf reads everything it needs
 * from the RWops during this call in any case.
 *
 * Some fonts have multiple "faces" included. The index specifies which face
 * to use from the font file. Font files with only one face should specify
 * zero for the index.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param src an SDL_RWops to provide a font file's data.
 * \param freesrc non-zero to close the RWops before returning, zero to leave
 *                it open.
 * \param ptsize point size to use for the newly-opened font.
 * \param index index of the face in the font file.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontIndexRW(src: PSDL_RWops; freesrc: cint; ptsize: cint; index: clong): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexRW' {$ENDIF} {$ENDIF};

{*
 * Create a font from a file, using target resolutions (in DPI).
 *
 * DPI scaling only applies to scalable fonts (e.g. TrueType).
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param file path to font file.
 * \param ptsize point size to use for the newly-opened font.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontDPI(file: PAnsiChar; ptsize: cint; hdpi: cuint; vdpi: cuint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontDPI' {$ENDIF} {$ENDIF};

{*
 * Create a font from a file, using target resolutions (in DPI).
 *
 * DPI scaling only applies to scalable fonts (e.g. TrueType).
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * Some fonts have multiple "faces" included. The index specifies which face
 * to use from the font file. Font files with only one face should specify
 * zero for the index.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param file path to font file.
 * \param ptsize point size to use for the newly-opened font.
 * \param index index of the face in the font file.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontIndexDPI(file: PAnsiChar; ptsize: cint; index: clong; hdpi: cuint; vdpi: cuint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexDPI' {$ENDIF} {$ENDIF};

{*
 * Opens a font from an SDL_RWops with target resolutions (in DPI).
 *
 * DPI scaling only applies to scalable fonts (e.g. TrueType).
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * If `freesrc` is non-zero, the RWops will be closed before returning,
 * whether this function succeeds or not. SDL_ttf reads everything it needs
 * from the RWops during this call in any case.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param src an SDL_RWops to provide a font file's data.
 * \param freesrc non-zero to close the RWops before returning, zero to leave
 *                it open.
 * \param ptsize point size to use for the newly-opened font.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontDPIRW(src: PSDL_RWops; freesrc: cint; ptsize: cint; hdpi: cuint; vdpi: cuint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontDPIRW' {$ENDIF} {$ENDIF};

{*
 * Opens a font from an SDL_RWops with target resolutions (in DPI).
 *
 * DPI scaling only applies to scalable fonts (e.g. TrueType).
 *
 * Some .fon fonts will have several sizes embedded in the file, so the point
 * size becomes the index of choosing which size. If the value is too high,
 * the last indexed size will be the default.
 *
 * If `freesrc` is non-zero, the RWops will be closed before returning,
 * whether this function succeeds or not. SDL_ttf reads everything it needs
 * from the RWops during this call in any case.
 *
 * Some fonts have multiple "faces" included. The index specifies which face
 * to use from the font file. Font files with only one face should specify
 * zero for the index.
 *
 * When done with the returned TTF_Font, use TTF_CloseFont() to dispose of it.
 *
 * \param src an SDL_RWops to provide a font file's data.
 * \param freesrc non-zero to close the RWops before returning, zero to leave
 *                it open.
 * \param ptsize point size to use for the newly-opened font.
 * \param index index of the face in the font file.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns a valid TTF_Font, or nil on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_CloseFont
  }
function TTF_OpenFontIndexDPIRW(src: PSDL_RWops; freesrc: cint; ptsize: cint; index: clong; hdpi: cuint; vdpi: cuint): PTTF_Font; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_OpenFontIndexDPIRW' {$ENDIF} {$ENDIF};

{*
 * Set a font's size dynamically.
 *
 * This clears already-generated glyphs, if any, from the cache.
 *
 * \param font the font to resize.
 * \param ptsize the new point size.
 * \returns 0 if successful, -1 on error
 *
 * \since This function is available since SDL_ttf 2.0.18.
  }
function TTF_SetFontSize(font: PTTF_Font; ptsize: cint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSize' {$ENDIF} {$ENDIF};

{*
 * Set font size dynamically with target resolutions (in DPI).
 *
 * This clears already-generated glyphs, if any, from the cache.
 *
 * \param font the font to resize.
 * \param ptsize the new point size.
 * \param hdpi the target horizontal DPI.
 * \param vdpi the target vertical DPI.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
  }
function TTF_SetFontSizeDPI(font: PTTF_Font; ptsize: cint; hdpi: cuint; vdpi: cuint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSizeDPI' {$ENDIF} {$ENDIF};

{*
 * Font style flags
  }
const
  TTF_STYLE_NORMAL        = $00;
  TTF_STYLE_BOLD          = $01;
  TTF_STYLE_ITALIC        = $02;
  TTF_STYLE_UNDERLINE     = $04;
  TTF_STYLE_STRIKETHROUGH = $08;

{*
 * Query a font's current style.
 *
 * The font styles are a set of bit flags, OR'd together:
 *
 * - `TTF_STYLE_NORMAL` (is zero)
 * - `TTF_STYLE_BOLD`
 * - `TTF_STYLE_ITALIC`
 * - `TTF_STYLE_UNDERLINE`
 * - `TTF_STYLE_STRIKETHROUGH`
 *
 * \param font the font to query.
 * \returns the current font style, as a set of bit flags.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SetFontStyle
  }
function TTF_GetFontStyle(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontStyle' {$ENDIF} {$ENDIF};

{*
 * Set a font's current style.
 *
 * Setting the style clears already-generated glyphs, if any, from the cache.
 *
 * The font styles are a set of bit flags, OR'd together:
 *
 * - `TTF_STYLE_NORMAL` (is zero)
 * - `TTF_STYLE_BOLD`
 * - `TTF_STYLE_ITALIC`
 * - `TTF_STYLE_UNDERLINE`
 * - `TTF_STYLE_STRIKETHROUGH`
 *
 * \param font the font to set a new style on.
 * \param style the new style values to set, OR'd together.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_GetFontStyle
  }
procedure TTF_SetFontStyle(font: PTTF_Font; style: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontStyle' {$ENDIF} {$ENDIF};

{*
 * Query a font's current outline.
 *
 * \param font the font to query.
 * \returns the font's current outline value.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SetFontOutline
  }
function TTF_GetFontOutline(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontOutline' {$ENDIF} {$ENDIF};

{*
 * Set a font's current outline.
 *
 * \param font the font to set a new outline on.
 * \param outline positive outline value, 0 to default.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_GetFontOutline
  }
procedure TTF_SetFontOutline(font: PTTF_Font; outline: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontOutline' {$ENDIF} {$ENDIF};

{*
 * Hinting flags
  }
const
  TTF_HINTING_NORMAL         = 0;
  TTF_HINTING_LIGHT          = 1;
  TTF_HINTING_MONO           = 2;
  TTF_HINTING_NONE           = 3;
  TTF_HINTING_LIGHT_SUBPIXEL = 4;

{*
 * Query a font's current FreeType hinter setting.
 *
 * The hinter setting is a single value:
 *
 * - `TTF_HINTING_NORMAL`
 * - `TTF_HINTING_LIGHT`
 * - `TTF_HINTING_MONO`
 * - `TTF_HINTING_NONE`
 * - `TTF_HINTING_LIGHT_SUBPIXEL` (available in SDL_ttf 2.0.18 and later)
 *
 * \param font the font to query.
 * \returns the font's current hinter value.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SetFontHinting
  }
function TTF_GetFontHinting(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontHinting' {$ENDIF} {$ENDIF};

{*
 * Set a font's current hinter setting.
 *
 * Setting it clears already-generated glyphs, if any, from the cache.
 *
 * The hinter setting is a single value:
 *
 * - `TTF_HINTING_NORMAL`
 * - `TTF_HINTING_LIGHT`
 * - `TTF_HINTING_MONO`
 * - `TTF_HINTING_NONE`
 * - `TTF_HINTING_LIGHT_SUBPIXEL` (available in SDL_ttf 2.0.18 and later)
 *
 * \param font the font to set a new hinter setting on.
 * \param hinting the new hinter setting.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_GetFontHinting
  }
procedure TTF_SetFontHinting(font: PTTF_Font; hinting: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontHinting' {$ENDIF} {$ENDIF};

{*
 * Special layout option for rendering wrapped text
  }
const
  TTF_WRAPPED_ALIGN_LEFT   = 0;
  TTF_WRAPPED_ALIGN_CENTER = 1;
  TTF_WRAPPED_ALIGN_RIGHT  = 2;

{*
 * Query a font's current wrap alignment option.
 *
 * The wrap alignment option can be one of the following:
 *
 * - `TTF_WRAPPED_ALIGN_LEFT`
 * - `TTF_WRAPPED_ALIGN_CENTER`
 * - `TTF_WRAPPED_ALIGN_RIGHT`
 *
 * \param font the font to query.
 * \returns the font's current wrap alignment option.
 *
 * \since This function is available since SDL_ttf 2.20.0.
 *
 * \sa TTF_SetFontWrappedAlign
  }
function TTF_GetFontWrappedAlign(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontWrappedAlign' {$ENDIF} {$ENDIF};

{*
 * Set a font's current wrap alignment option.
 *
 * The wrap alignment option can be one of the following:
 *
 * - `TTF_WRAPPED_ALIGN_LEFT`
 * - `TTF_WRAPPED_ALIGN_CENTER`
 * - `TTF_WRAPPED_ALIGN_RIGHT`
 *
 * \param font the font to set a new wrap alignment option on.
 * \param align the new wrap alignment option.
 *
 * \since This function is available since SDL_ttf 2.20.0.
 *
 * \sa TTF_GetFontWrappedAlign
  }
procedure TTF_SetFontWrappedAlign(font: PTTF_Font; align: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontWrappedAlign' {$ENDIF} {$ENDIF};

{*
 * Query the total height of a font.
 *
 * This is usually equal to point size.
 *
 * \param font the font to query.
 * \returns the font's height.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontHeight(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontHeight' {$ENDIF} {$ENDIF};

{*
 * Query the offset from the baseline to the top of a font.
 *
 * This is a positive value, relative to the baseline.
 *
 * \param font the font to query.
 * \returns the font's ascent.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontAscent(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontAscent' {$ENDIF} {$ENDIF};

{*
 * Query the offset from the baseline to the bottom of a font.
 *
 * This is a negative value, relative to the baseline.
 *
 * \param font the font to query.
 * \returns the font's descent.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontDescent(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontDescent' {$ENDIF} {$ENDIF};

{*
 * Query the recommended spacing between lines of text for a font.
 *
 * \param font the font to query.
 * \returns the font's recommended spacing.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontLineSkip(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontLineSkip' {$ENDIF} {$ENDIF};

{*
 * Query whether or not kerning is allowed for a font.
 *
 * \param font the font to query.
 * \returns non-zero if kerning is enabled, zero otherwise.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_GetFontKerning(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerning' {$ENDIF} {$ENDIF};

{*
 * Set if kerning is allowed for a font.
 *
 * Newly-opened fonts default to allowing kerning. This is generally a good
 * policy unless you have a strong reason to disable it, as it tends to
 * produce better rendering (with kerning disabled, some fonts might render
 * the word `kerning` as something that looks like `keming` for example).
 *
 * \param font the font to set kerning on.
 * \param allowed non-zero to allow kerning, zero to disallow.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
procedure TTF_SetFontKerning(font: PTTF_Font; allowed: cint); cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontKerning' {$ENDIF} {$ENDIF};

{*
 * Query the number of faces of a font.
 *
 * \param font the font to query.
 * \returns the number of FreeType font faces.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontFaces(font: PTTF_Font): clong; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaces' {$ENDIF} {$ENDIF};

{*
 * Query whether a font is fixed-width.
 *
 * A "fixed-width" font means all glyphs are the same width across; a
 * lowercase 'i' will be the same size across as a capital 'W', for example.
 * This is common for terminals and text editors, and other apps that treat
 * text as a grid. Most other things (WYSIWYG word processors, web pages, etc)
 * are more likely to not be fixed-width in most cases.
 *
 * \param font the font to query.
 * \returns non-zero if fixed-width, zero if not.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontFaceIsFixedWidth(font: PTTF_Font): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceIsFixedWidth' {$ENDIF} {$ENDIF};

{*
 * Query a font's family name.
 *
 * This string is dictated by the contents of the font file.
 *
 * Note that the returned string is to internal storage, and should not be
 * modifed or free'd by the caller. The string becomes invalid, with the rest
 * of the font, when `font` is handed to TTF_CloseFont().
 *
 * \param font the font to query.
 * \returns the font's family name.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontFaceFamilyName(font: PTTF_Font): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceFamilyName' {$ENDIF} {$ENDIF};

{*
 * Query a font's style name.
 *
 * This string is dictated by the contents of the font file.
 *
 * Note that the returned string is to internal storage, and should not be
 * modifed or free'd by the caller. The string becomes invalid, with the rest
 * of the font, when `font` is handed to TTF_CloseFont().
 *
 * \param font the font to query.
 * \returns the font's style name.
 *
 * \since This function is available since SDL_ttf 2.0.12.
  }
function TTF_FontFaceStyleName(font: PTTF_Font): PAnsiChar; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_FontFaceStyleName' {$ENDIF} {$ENDIF};

{*
 * Check whether a glyph is provided by the font for a 16-bit codepoint.
 *
 * Note that this version of the function takes a 16-bit character code, which
 * covers the Basic Multilingual Plane, but is insufficient to cover the
 * entire set of possible Unicode values, including emoji glyphs. You should
 * use TTF_GlyphIsProvided32() instead, which offers the same functionality
 * but takes a 32-bit codepoint instead.
 *
 * The only reason to use this function is that it was available since the
 * beginning of time, more or less.
 *
 * \param font the font to query.
 * \param ch the character code to check.
 * \returns non-zero if font provides a glyph for this character, zero if not.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_GlyphIsProvided32
  }
function TTF_GlyphIsProvided(font: PTTF_Font; ch: cuint16): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphIsProvided' {$ENDIF} {$ENDIF};

{*
 * Check whether a glyph is provided by the font for a 32-bit codepoint.
 *
 * This is the same as TTF_GlyphIsProvided(), but takes a 32-bit character
 * instead of 16-bit, and thus can query a larger range. If you are sure
 * you'll have an SDL_ttf that's version 2.0.18 or newer, there's no reason
 * not to use this function exclusively.
 *
 * \param font the font to query.
 * \param ch the character code to check.
 * \returns non-zero if font provides a glyph for this character, zero if not.
 *
 * \since This function is available since SDL_ttf 2.0.18.
  }
function TTF_GlyphIsProvided32(font: PTTF_Font; ch: cuint32): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphIsProvided32' {$ENDIF} {$ENDIF};

{*
 * Query the metrics (dimensions) of a font's 16-bit glyph.
 *
 * To understand what these metrics mean, here is a useful link:
 *
 * https://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
 *
 * Note that this version of the function takes a 16-bit character code, which
 * covers the Basic Multilingual Plane, but is insufficient to cover the
 * entire set of possible Unicode values, including emoji glyphs. You should
 * use TTF_GlyphMetrics32() instead, which offers the same functionality but
 * takes a 32-bit codepoint instead.
 *
 * The only reason to use this function is that it was available since the
 * beginning of time, more or less.
 *
 * \param font the font to query.
 * \param ch the character code to check.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_GlyphMetrics32
  }
function TTF_GlyphMetrics(font: PTTF_Font; ch: cuint16; minx: pcint; maxx: pcint; miny: pcint; maxy: pcint; advance: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphMetrics' {$ENDIF} {$ENDIF};

{*
 * Query the metrics (dimensions) of a font's 32-bit glyph.
 *
 * To understand what these metrics mean, here is a useful link:
 *
 * https://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
 *
 * This is the same as TTF_GlyphMetrics(), but takes a 32-bit character
 * instead of 16-bit, and thus can query a larger range. If you are sure
 * you'll have an SDL_ttf that's version 2.0.18 or newer, there's no reason
 * not to use this function exclusively.
 *
 * \param font the font to query.
 * \param ch the character code to check.
 *
 * \since This function is available since SDL_ttf 2.0.18.
  }
function TTF_GlyphMetrics32(font: PTTF_Font; ch: cuint32; minx: pcint; maxx: pcint; miny: pcint; maxy: pcint; advance: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GlyphMetrics32' {$ENDIF} {$ENDIF};

{*
 * Calculate the dimensions of a rendered string of Latin1 text.
 *
 * This will report the width and height, in pixels, of the space that the
 * specified string will take to fully render.
 *
 * This does not need to render the string to do this calculation.
 *
 * You almost certainly want TTF_SizeUTF8() unless you're sure you have a
 * 1-byte Latin1 encoding. US ASCII characters will work with either function,
 * but most other Unicode characters packed into a `const char *` will need
 * UTF-8.
 *
 * \param font the font to query.
 * \param text text to calculate, in Latin1 encoding.
 * \param w will be filled with width, in pixels, on return.
 * \param h will be filled with height, in pixels, on return.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SizeUTF8
 * \sa TTF_SizeUNICODE
  }
function TTF_SizeText(font: PTTF_Font; text: PAnsiChar; w: pcint; h: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeText' {$ENDIF} {$ENDIF};

{*
 * Calculate the dimensions of a rendered string of UTF-8 text.
 *
 * This will report the width and height, in pixels, of the space that the
 * specified string will take to fully render.
 *
 * This does not need to render the string to do this calculation.
 *
 * \param font the font to query.
 * \param text text to calculate, in UTF-8 encoding.
 * \param w will be filled with width, in pixels, on return.
 * \param h will be filled with height, in pixels, on return.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SizeUNICODE
  }
function TTF_SizeUTF8(font: PTTF_Font; text: PAnsiChar; w: pcint; h: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUTF8' {$ENDIF} {$ENDIF};

{*
 * Calculate the dimensions of a rendered string of UCS-2 text.
 *
 * This will report the width and height, in pixels, of the space that the
 * specified string will take to fully render.
 *
 * This does not need to render the string to do this calculation.
 *
 * Please note that this function is named "Unicode" but currently expects
 * UCS-2 encoding (16 bits per codepoint). This does not give you access to
 * large Unicode values, such as emoji glyphs. These codepoints are accessible
 * through the UTF-8 version of this function.
 *
 * \param font the font to query.
 * \param text text to calculate, in UCS-2 encoding.
 * \param w will be filled with width, in pixels, on return.
 * \param h will be filled with height, in pixels, on return.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.12.
 *
 * \sa TTF_SizeUTF8
  }
function TTF_SizeUNICODE(font: PTTF_Font; text: pcuint16; w: pcint; h: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SizeUNICODE' {$ENDIF} {$ENDIF};

{*
 * Calculate how much of a Latin1 string will fit in a given width.
 *
 * This reports the number of characters that can be rendered before reaching
 * `measure_width`.
 *
 * This does not need to render the string to do this calculation.
 *
 * You almost certainly want TTF_MeasureUTF8() unless you're sure you have a
 * 1-byte Latin1 encoding. US ASCII characters will work with either function,
 * but most other Unicode characters packed into a `const char *` will need
 * UTF-8.
 *
 * \param font the font to query.
 * \param text text to calculate, in Latin1 encoding.
 * \param measure_width maximum width, in pixels, available for the string.
 * \param count on return, filled with number of characters that can be
 *              rendered.
 * \param extent on return, filled with latest calculated width.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_MeasureText
 * \sa TTF_MeasureUTF8
 * \sa TTF_MeasureUNICODE
  }
function TTF_MeasureText(font: PTTF_Font; text: PAnsiChar; measure_width: cint; extent: pcint; count: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureText' {$ENDIF} {$ENDIF};

{*
 * Calculate how much of a UTF-8 string will fit in a given width.
 *
 * This reports the number of characters that can be rendered before reaching
 * `measure_width`.
 *
 * This does not need to render the string to do this calculation.
 *
 * \param font the font to query.
 * \param text text to calculate, in UTF-8 encoding.
 * \param measure_width maximum width, in pixels, available for the string.
 * \param count on return, filled with number of characters that can be
 *              rendered.
 * \param extent on return, filled with latest calculated width.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_MeasureText
 * \sa TTF_MeasureUTF8
 * \sa TTF_MeasureUNICODE
  }
function TTF_MeasureUTF8(font: PTTF_Font; text: PAnsiChar; measure_width: cint; extent: pcint; count: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureUTF8' {$ENDIF} {$ENDIF};

{*
 * Calculate how much of a UCS-2 string will fit in a given width.
 *
 * This reports the number of characters that can be rendered before reaching
 * `measure_width`.
 *
 * This does not need to render the string to do this calculation.
 *
 * Please note that this function is named "Unicode" but currently expects
 * UCS-2 encoding (16 bits per codepoint). This does not give you access to
 * large Unicode values, such as emoji glyphs. These codepoints are accessible
 * through the UTF-8 version of this function.
 *
 * \param font the font to query.
 * \param text text to calculate, in UCS-2 encoding.
 * \param measure_width maximum width, in pixels, available for the string.
 * \param count on return, filled with number of characters that can be
 *              rendered.
 * \param extent on return, filled with latest calculated width.
 * \returns 0 if successful, -1 on error.
 *
 * \since This function is available since SDL_ttf 2.0.18.
 *
 * \sa TTF_MeasureText
 * \sa TTF_MeasureUTF8
 * \sa TTF_MeasureUNICODE
  }
function TTF_MeasureUNICODE(font: PTTF_Font; text: pcuint16; measure_width: cint; extent: pcint; count: pcint): cint; cdecl;
  external SDL_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_MeasureUNICODE' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Solid(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Solid(font: PTTF_Font; text: pcuint16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Solid' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   If wrapLength is 0, only wrap on new lines.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Solid_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Solid_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Solid_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Solid_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Solid_Wrapped(font: PTTF_Font; text: pcUint16; fg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Solid_Wrapped' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   fast quality with the given font and color.  The 0 pixel is the
   colorkey, giving a transparent background, and the 1 pixel is set
   to the text color.  The glyph is rendered without any padding or
   centering in the X direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Solid(font: PTTF_Font; ch: cUint16; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Solid32(font: PTTF_Font; ch: cUint32; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Solid32' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Shaded(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Shaded(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Shaded' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given text at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   If wrapLength is 0, only wrap on new lines.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Shaded_Wrapped(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Shaded_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Shaded_Wrapped(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Shaded_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Shaded_Wrapped(font: PTTF_Font; text: pcUint16; fg, bg: TSDL_Color; wrapLength: cUint32): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Shaded_Wrapped' {$ENDIF} {$ENDIF};

{* Create an 8-bit palettized surface and render the given glyph at
   high quality with the given font and colors.  The 0 pixel is background,
   while other pixels have varying degrees of the foreground color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Shaded(font: PTTF_Font; ch: cUint16; fg, bg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Shaded32(font: PTTF_Font; ch: cUint32; fg, bg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Shaded32' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended(font: PTTF_Font; text: pcuint16; fg: TSDL_Color): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given text at high quality,
   using alpha blending to dither the font with the given color.
   Text is wrapped to multiple lines on line endings and on word boundaries
   if it extends beyond wrapLength in pixels.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderText_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderText_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUTF8_Blended_Wrapped(font: PTTF_Font; text: PAnsiChar; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUTF8_Blended_Wrapped' {$ENDIF} {$ENDIF};
function TTF_RenderUNICODE_Blended_Wrapped(font: PTTF_Font; text: pcuint16; fg: TSDL_Color; wrapLength: cuint32): PSDL_Surface cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderUNICODE_Blended_Wrapped' {$ENDIF} {$ENDIF};

{* Create a 32-bit ARGB surface and render the given glyph at high quality,
   using alpha blending to dither the font with the given color.
   The glyph is rendered without any padding or centering in the X
   direction, and aligned normally in the Y direction.
   This function returns the new surface, or NULL if there was an error.
*}
function TTF_RenderGlyph_Blended(font: PTTF_Font; ch: cUint16; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended' {$ENDIF} {$ENDIF};
function TTF_RenderGlyph_Blended32(font: PTTF_Font; ch: cUint32; fg: TSDL_Color): PSDL_Surface;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_RenderGlyph_Blended32' {$ENDIF} {$ENDIF};

{* For compatibility with previous versions, here are the old functions *}
function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
function TTF_RenderUNICODE(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface;

{* Set Direction and Script to be used for text shaping, when using HarfBuzz.
   - direction is of type hb_direction_t
   - script is of type hb_script_t

   This functions returns always 0, or -1 if SDL_ttf is not compiled with HarfBuzz
*}
function TTF_SetDirection(direction: cint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetDirection' {$ENDIF} {$ENDIF};
function TTF_SetScript(script: cint): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetScript' {$ENDIF} {$ENDIF};

{* Close an opened font file *}
procedure TTF_CloseFont(font: PTTF_Font) cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_CloseFont' {$ENDIF} {$ENDIF};

{* De-initialize the TTF engine *}
procedure TTF_Quit() cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_Quit' {$ENDIF} {$ENDIF};

{* Check if the TTF engine is initialized *}
function TTF_WasInit: Boolean cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_WasInit' {$ENDIF} {$ENDIF};

{* Get the kerning size of two glyphs

   DEPRECATED: this function requires FreeType font indexes, not glyphs,
     by accident, which we don't expose through this API, so it could give
     wildly incorrect results, especially with non-ASCII values.
     Going forward, please use TTF_GetFontKerningSizeGlyphs() instead, which
     does what you probably expected this function to do.
*}
function TTF_GetFontKerningSize(font: PTTF_Font; prev_index, index: cint): cint cdecl;
  external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSize' {$ENDIF} {$ENDIF};
  deprecated 'This function requires FreeType font indexes, not glyphs. Use TTF_GetFontKerningSizeGlyphs() instead';

{* Get the kerning size of two glyphs *}
function TTF_GetFontKerningSizeGlyphs(font: PTTF_Font; previous_ch, ch: cUint16): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSizeGlyphs' {$ENDIF} {$ENDIF};
function TTF_GetFontKerningSizeGlyphs32(font: PTTF_Font; previous_ch, ch: cUint32): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontKerningSizeGlyphs32' {$ENDIF} {$ENDIF};

{* Enable Signed Distance Field rendering (with the Blended APIs) *}
function TTF_SetFontSDF(font: PTTF_Font; on_off: TSDL_Bool): cint;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_SetFontSDF' {$ENDIF} {$ENDIF};
function TTF_GetFontSDF(font: PTTF_Font): TSDL_Bool;
  cdecl; external TTF_LibName {$IFDEF DELPHI} {$IFDEF MACOS} name '_TTF_GetFontSDF' {$ENDIF} {$ENDIF};

{* We'll use SDL for reporting errors *}
function TTF_SetError(const fmt: PAnsiChar): cint32; cdecl;
function TTF_GetError: PAnsiChar; cdecl;

implementation

Procedure SDL_TTF_VERSION(Out X:TSDL_Version);
begin
  x.major := SDL_TTF_MAJOR_VERSION;
  x.minor := SDL_TTF_MINOR_VERSION;
  x.patch := SDL_TTF_PATCHLEVEL;
end;

function TTF_SetError(const fmt: PAnsiChar): cint32; cdecl;
begin
  Result := SDL_SetError(fmt);
end;

function TTF_GetError: PAnsiChar; cdecl;
begin
  Result := SDL_GetError();
end;

function TTF_RenderText(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderText_Shaded(font, text, fg, bg);
end;

function TTF_RenderUTF8(font: PTTF_Font; text: PAnsiChar; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUTF8_Shaded(font, text, fg, bg);
end;

function TTF_RenderUNICODE(font: PTTF_Font; text: pcuint16; fg, bg: TSDL_Color): PSDL_Surface;
begin
  Result := TTF_RenderUNICODE_Shaded(font, text, fg, bg);
end;

end.

