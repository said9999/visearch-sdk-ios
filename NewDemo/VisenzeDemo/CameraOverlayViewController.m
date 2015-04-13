//
//  CameraOverlayViewController.m
//  VisenzeDemo
//
//  Created by Yaoxuan on 3/24/15.
//  Copyright (c) 2015 Visenze. All rights reserved.
//

#import "CameraOverlayViewController.h"
#import "ImageCropViewController.h"

@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // start a session with medium video quality
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // sync image preview with video preview
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
        [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    captureVideoPreviewLayer.frame = self.imagePreview.bounds;
    [self.imagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    // init with rear camera
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"ERROR: trying to open camera: %@", error);
    }
    [session addInput:input];
    
    // stored captured images into output
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc]
        initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [session addOutput:self.stillImageOutput];
    
    [session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBActions

- (IBAction)shootClicked:(id)sender {
    // search video connection
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    
    // retrieve image from the connection
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
         }else {
             NSLog(@"no attachments");
         }
         
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        self.capturedImage = [[UIImage alloc] initWithData:imageData];
        
        if (self.capturedImage) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ImageCropViewController *vc = (ImageCropViewController *)[sb instantiateViewControllerWithIdentifier:@"image_crop"];
            
            vc.image = self.capturedImage;
            
            [self presentViewController:vc animated:NO completion:nil];
        }

     }];
}

- (IBAction)backClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
