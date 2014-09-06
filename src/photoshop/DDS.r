
///////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2014, Brendan Bolles
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// *	   Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// *	   Redistributions in binary form must reproduce the above
// copyright notice, this list of conditions and the following disclaimer
// in the documentation and/or other materials provided with the
// distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
///////////////////////////////////////////////////////////////////////////

// ------------------------------------------------------------------------
//
// DDS Photoshop plug-in
//
// by Brendan Bolles <brendan@fnordware.com>
//
// ------------------------------------------------------------------------

//-------------------------------------------------------------------------------
//	Definitions -- Required by include files.
//-------------------------------------------------------------------------------

#include "DDS_version.h"

#define plugInName			"DDS"
#define plugInCopyrightYear	DDS_Copyright_Year
#define plugInDescription DDS_Description
#define VersionString 	DDS_Version_String
#define ReleaseString	DDS_Build_Date_Manual
#define CurrentYear		DDS_Build_Year

//-------------------------------------------------------------------------------
//	Definitions -- Required by other resources in this rez file.
//-------------------------------------------------------------------------------

// Dictionary (aete) resources:

#define vendorName			"fnord"
#define plugInAETEComment 	DDS_Description

#define plugInSuiteID		'sdK4'
#define plugInClassID		'fDDS'
#define plugInEventID		typeNull // must be this

//-------------------------------------------------------------------------------
//	Set up included files for Macintosh and Windows.
//-------------------------------------------------------------------------------

#include "PIDefines.h"

#ifdef __PIMac__
	#include "Types.r"
	#include "SysTypes.r"
	#include "PIGeneral.r"
	//#include "PIUtilities.r"
	//#include "DialogUtilities.r"
#elif defined(__PIWin__)
	#include "PIGeneral.h"
	//#include "PIUtilities.r"
	//#include "WinDialogUtils.r"
#endif

#ifndef ResourceID
	#define ResourceID		16000
#endif

#include "PITerminology.h"
#include "PIActions.h"

#include "DDS_Terminology.h"

//-------------------------------------------------------------------------------
//	PiPL resource
//-------------------------------------------------------------------------------

resource 'PiPL' (ResourceID, plugInName " PiPL", purgeable)
{
    {
		Kind { ImageFormat },
		Name { plugInName },

		//Category { "DDS" },
		//Priority { 1 }, // Can use this to override a built-in Photoshop plug-in

		Version { (latestFormatVersion << 16) | latestFormatSubVersion },

		#ifdef __PIMac__
			#if (defined(__x86_64__))
				CodeMacIntel64 { "PluginMain" },
			#endif
		#else
			#if defined(_WIN64)
				CodeWin64X86 { "PluginMain" },
			#else
				CodeWin32X86 { "PluginMain" },
			#endif
		#endif
	
		// ClassID, eventID, aete ID, uniqueString:
		HasTerminology { plugInClassID, plugInEventID, ResourceID, vendorName " " plugInName },
		
		SupportedModes
		{
			noBitmap, noGrayScale,
			noIndexedColor, doesSupportRGBColor,
			noCMYKColor, noHSLColor,
			noHSBColor, noMultichannel,
			noDuotone, noLABColor
		},
			
		EnableInfo { "in (PSHOP_ImageMode, RGBMode, RGBColorMode)" },
	
		FmtFileType { 'DDS ', '8BIM' },
		ReadTypes { { 'DDS ', '    ' } },
		ReadExtensions { { 'dds ' } },
		WriteExtensions { { 'dds ' } },
		FilteredExtensions { { 'dds ' } },
		FormatFlags { fmtSavesImageResources, //(by saying we do, PS won't store them, thereby avoiding problems)
		              fmtCanRead, 
					  fmtCanWrite, 
					  fmtCanWriteIfRead, 
					  fmtCanWriteTransparency,
					  fmtCannotCreateThumbnail },
		PlugInMaxSize { 8192, 8192 },
		FormatMaxSize { { 8192, 8192 } },
		FormatMaxChannels { {   0, 0, 0, 5, 0, 0, 
							   0, 0, 0, 0, 0, 0 } },
		//FormatICCFlags { 	iccCanEmbedGray,
		//					iccCanEmbedIndexed,
		//					iccCanEmbedRGB,
		//					iccCannotEmbedCMYK },
		},
	};


//-------------------------------------------------------------------------------
//	PiMI resource (kept for backward compatibility)
//-------------------------------------------------------------------------------

resource 'PiMI' (ResourceID, plugInName " PiMI", purgeable)
{
	latestFormatVersion, 	/* Version, subVersion, and priority of the interface */
	latestFormatSubVersion,
	0,

	supportsGrayScale +
	supportsRGBColor,			/* Supported Image Modes */
	'    ',						/* Required host */
	
	{
		canRead,
		cannotReadAll,
		canWrite,
		canWriteIfRead,
		savesResources,
		{  0, 0, 0, 5,		/* Maximum # of channels for each plug-in mode */
		  0, 0, 0, 0,
		  0, 0,  0,  0,
		   0,  0,  0,  0 },
		32767,				/* Maximum rows allowed in document */
		32767,				/* Maximum columns allowed in document */
		'DDS ',				/* The file type if we create a file. */
		'8BIM',				/* The creator type if we create a file. */
		{					/* The type-creator pairs supported. */
			'8B1F', '    '
		},
		{					/* The extensions supported. */
		}
	},
	
};

//-------------------------------------------------------------------------------
//	Dictionary (scripting) resource
//-------------------------------------------------------------------------------

resource 'aete' (ResourceID, plugInName " dictionary", purgeable)
{
	1, 0, english, roman,									/* aete version and language specifiers */
	{
		vendorName,											/* vendor suite name */
		"DDS format",							/* optional description */
		plugInSuiteID,										/* suite ID */
		1,													/* suite code, must be 1 */
		1,													/* suite level, must be 1 */
		{},													/* structure for filters */
		{													/* non-filter plug-in class here */
			"DDS",										/* unique class name */
			plugInClassID,									/* class ID, must be unique or Suite ID */
			plugInAETEComment,								/* optional description */
			{												/* define inheritance */
				"$$$/private/AETE/Inheritance=<Inheritance>",							/* must be exactly this */
				keyInherits,								/* must be keyInherits */
				classFormat,								/* parent: Format, Import, Export */
				"parent class format",						/* optional description */
				flagsSingleProperty,						/* if properties, list below */
							
				"DDS Format",
				keyDDSformat,
				typeEnumerated,
				"DDS compression format",
				flagsSingleProperty,
				
				"Mipmap",
				keyDDSmipmap,
				typeBoolean,
				"Create Mipmaps",
				flagsSingleProperty,
				
				"Alpha Channel",
				keyDDSalpha,
				typeEnumerated,
				"Source of the alpha channel",
				flagsSingleProperty,
			},
			{}, /* elements (not supported) */
			/* class descriptions */
		},
		{}, /* comparison ops (not supported) */
		{	/* any enumerations */
			typeAlphaChannel,
			{
                "None",
                alphaChannelNone,
                "No alpha channel",

                "Transparency",
                alphaChannelTransparency,
                "Get alpha from Transparency",

                "Channel",
                alphaChannelChannel,
                "Get alpha from channels palette"
			},
			typeDDSformat,
			{
                "DXT1",
                formatDXT1,
                "DXT1 format",
                
                "DXT2",
                formatDXT2,
                "DXT2 format",
                
                "DXT3",
                formatDXT3,
                "DXT3 format",
                
                "DXT4",
                formatDXT4,
                "DXT4 format",
                
                "DXT5",
                formatDXT5,
                "DXT5 format",
			}
		}
	}
};


#ifdef __PIMac__

//-------------------------------------------------------------------------------
//	Version 'vers' resources.
//-------------------------------------------------------------------------------

resource 'vers' (1, plugInName " Version", purgeable)
{
	5, 0x50, final, 0, verUs,
	VersionString,
	VersionString " ©" plugInCopyrightYear " fnord"
};

resource 'vers' (2, plugInName " Version", purgeable)
{
	5, 0x50, final, 0, verUs,
	VersionString,
	"by Brendan Bolles"
};


#endif // __PIMac__


