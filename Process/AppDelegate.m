//
//  AppDelegate.m
//  Process
//
//  Created by Nahuel Proietto on 22/8/16.
//  Copyright © 2016 Nahuel Proietto. All rights reserved.
//

#import "AppDelegate.h"
#import <Quartz/Quartz.h>

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )
#define kAlpha 255;

typedef struct Colors
{
    int red;
    int green;
    int blue;
    
} Color;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSImage *landscape = [NSImage imageNamed:@"Landscape.png"];
    
    [imageViewIN setImage:landscape];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

-(IBAction)inverseFilter:(id)sender
{
    // process
    NSData *tiffRep = [[imageViewIN image]TIFFRepresentation];
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:tiffRep];
    long n = [imageRep bitsPerPixel] / 8;           // Bytes per pixel
    long w = [imageRep pixelsWide];
    long h = [imageRep pixelsHigh];
    long rowBytes = [imageRep bytesPerRow];
    
    NSImage *destImage = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    NSBitmapImageRep *destImageRep = [[NSBitmapImageRep alloc]
                                       initWithBitmapDataPlanes:NULL
                                       pixelsWide:w
                                       pixelsHigh:h
                                       bitsPerSample:8
                                       samplesPerPixel:n
                                       hasAlpha:[imageRep hasAlpha]
                                       isPlanar:NO
                                       colorSpaceName:[imageRep colorSpaceName]
                                       bytesPerRow:rowBytes
                                       bitsPerPixel:32];
    
    unsigned char *srcData = [imageRep bitmapData];
    unsigned char *destData = [destImageRep bitmapData];
    
    NSLog(@"Bitmap Format: %lu", (unsigned long)[imageRep bitmapFormat]);

    int row, col;
    for (row = 0; row < h; row++)
    {
        unsigned char* srcRowStart = (unsigned char*)(srcData + (row * rowBytes));
        unsigned char* nextChannel = srcRowStart;
        
        for (col = 0; col < w; col++)
        {
            // red
            *(destData) = 255 - *(nextChannel);
            destData++; nextChannel++;
            // green
            *(destData) = 255 - *(nextChannel);
            destData++; nextChannel++;
            // blue
            *(destData) = 255 - *(nextChannel);
            destData++; nextChannel++;
            // alpha
            *(destData) = *nextChannel;
            destData++; nextChannel++;
        }
    }
    
    [destImage addRepresentation:destImageRep];
    [imageViewOUT setImage:destImage];

}

-(IBAction)flipRedGreen:(id)sender
{
    // process
    NSData *tiffRep = [[imageViewIN image]TIFFRepresentation];
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:tiffRep];
    long n = [imageRep bitsPerPixel] / 8;           // Bytes per pixel
    long w = [imageRep pixelsWide];
    long h = [imageRep pixelsHigh];
    long rowBytes = [imageRep bytesPerRow];
    
    NSImage *destImage = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    NSBitmapImageRep *destImageRep = [[NSBitmapImageRep alloc]
                                      initWithBitmapDataPlanes:NULL
                                      pixelsWide:w
                                      pixelsHigh:h
                                      bitsPerSample:8
                                      samplesPerPixel:n
                                      hasAlpha:[imageRep hasAlpha]
                                      isPlanar:NO
                                      colorSpaceName:[imageRep colorSpaceName]
                                      bytesPerRow:rowBytes
                                      bitsPerPixel:32];
    
    unsigned char *srcData = [imageRep bitmapData];
    unsigned char *destData = [destImageRep bitmapData];
    
    NSLog(@"Bitmap Format: %lu", (unsigned long)[imageRep bitmapFormat]);
    
    int row, col;
    for (row = 0; row < h; row++)
    {
        unsigned char* srcRowStart = (unsigned char*)(srcData + (row * rowBytes));
        unsigned char* nextChannel = srcRowStart;
        
        for (col = 0; col < w; col++)
        {
            // red
            *(destData) = 255 - *(nextChannel + 1);
            destData++; nextChannel++;
            // green
            *(destData) = 255 - *(nextChannel - 1);
            destData++; nextChannel++;
            // blue
            *(destData) = 255 - *(nextChannel);
            destData++; nextChannel++;
            // alpha
            *(destData) = *nextChannel;
            destData++; nextChannel++;
        }
    }
    
    [destImage addRepresentation:destImageRep];
    [imageViewOUT setImage:destImage];
}

-(IBAction)convolutionFilter:(id)sender
{
    // process
    NSData *tiffRep = [[imageViewIN image]TIFFRepresentation];
    NSBitmapImageRep* imageRep = [[NSBitmapImageRep alloc] initWithData:tiffRep];
    long n = [imageRep bitsPerPixel] / 8;           // Bytes per pixel
    long w = [imageRep pixelsWide];
    long h = [imageRep pixelsHigh];
    long rowBytes = [imageRep bytesPerRow];
    
    NSImage *destImage = [[NSImage alloc] initWithSize:NSMakeSize(w, h)];
    NSBitmapImageRep *destImageRep = [[NSBitmapImageRep alloc]
                                      initWithBitmapDataPlanes:NULL
                                      pixelsWide:w
                                      pixelsHigh:h
                                      bitsPerSample:8
                                      samplesPerPixel:n
                                      hasAlpha:[imageRep hasAlpha]
                                      isPlanar:NO
                                      colorSpaceName:[imageRep colorSpaceName]
                                      bytesPerRow:rowBytes
                                      bitsPerPixel:32];
    
    unsigned char *srcData = [imageRep bitmapData];
    unsigned char *destData = [destImageRep bitmapData];
    
    NSLog(@"Bitmap Format: %lu", (unsigned long)[imageRep bitmapFormat]);
    
    NSUInteger row, col;
    for (row = 0; row < w; row++)
    {
        unsigned char* srcRowStart = (unsigned char*)(srcData + (row * rowBytes));
        unsigned char* nextChannel = srcRowStart;
        
        for (col = 0; col < h; col++)
        {
            Color color = [self convoluteImage:nextChannel
                                         width:w
                                        height:h];
            *(destData) = color.red;
            destData++; nextChannel++;
            *(destData) = color.green;
            destData++; nextChannel++;
            *(destData) = color.blue;
            destData++; nextChannel++;
            *(destData) = kAlpha;
            destData++; nextChannel++;
        }
    }
    
    [destImage addRepresentation:destImageRep];
    [imageViewOUT setImage:destImage];
}

// Convolution alt 01

-(Color)convoluteImage:(unsigned char*)image
                 width:(long)w
                height:(long)h
{
    // matriz de convolución kernel 3x3
    // https://docs.gimp.org/es/plug-in-convmatrix.html
    // salida ejemplo (40*0)+(42*0)+(46*0) + (46*-1)+(50*1)+(55*0) + (52*0)+(56*0)+(58*0) = 95.
    // kernel sharpness float matrix[3][3] = {{0, -1, 0},{-1, 5, -1},{0, -1, 0}};
    // kernel edges float matrix[3][3] = {{0, 1, 0},{1, -4, 1},{0, 1, 0}};
    
    float matrix[3][3] = {{0, 1, 0},{1, -4, 1},{0, 1, 0}};
    
    float rtotal = 0.0;
    float gtotal = 0.0;
    float btotal = 0.0;
    float atotal = 0.0;
    int kernelsize = 3;
    int counter = 0;
    int offset = counter-((kernelsize*kernelsize)/2);
    
    for (int i = 0; i < kernelsize; i++)
    {
        for (int j = 0; j < kernelsize; j++)
        {
            offset = counter-ceil((kernelsize*kernelsize)/2);
            offset *= 4;
            rtotal += *(image+(int)offset) * matrix[i][j];
            gtotal += *(image+(int)offset+1) * matrix[i][j];
            btotal += *(image+(int)offset+2) * matrix[i][j];
            atotal += *(image+(int)offset+3) * matrix[i][j];
            counter++;
        }
    }
    
    rtotal = MAX( MIN((int)rtotal,255), 0);
    gtotal = MAX( MIN((int)gtotal,255), 0);
    btotal = MAX( MIN((int)btotal,255), 0);
    atotal = MAX( MIN((int)atotal,255), 0);
    
    Color pixel;
    pixel.red = rtotal;
    pixel.green = gtotal;
    pixel.blue = btotal;
    
    return pixel;
    
}


@end
