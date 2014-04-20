#import <UIKit/UIKit.h>

@class  HFImageEditorViewController;

@protocol HFImageEditorFrame
@required
@property(nonatomic,assign) CGRect cropRect;
@end

@protocol HFImageEditorDelegate <NSObject>

- (void)imageCropper:(HFImageEditorViewController *)cropperViewController divideCounts:(NSInteger)divideCounts didFinished:(UIImage *)editedImage;

@end

typedef void(^HFImageEditorDoneCallback)(UIImage *image, BOOL canceled);

@interface HFImageEditorViewController : UIViewController<UIGestureRecognizerDelegate>

@property(nonatomic,copy) HFImageEditorDoneCallback doneCallback;
@property(nonatomic,copy) UIImage *sourceImage;
@property(nonatomic,copy) UIImage *previewImage;
@property(nonatomic,assign) CGSize cropSize;
@property(nonatomic,assign) CGRect cropRect;
@property(nonatomic,assign) CGFloat outputWidth;
@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;

@property(nonatomic,assign) BOOL panEnabled;
@property(nonatomic,assign) BOOL rotateEnabled;
@property(nonatomic,assign) BOOL scaleEnabled;
@property(nonatomic,assign) BOOL tapToResetEnabled;
@property(nonatomic,assign) BOOL checkBounds;

@property(nonatomic,readonly) CGRect cropBoundsInSourceImage;
@property (nonatomic, assign) NSInteger divideCounts; // remember portion count
@property (nonatomic, assign) id<HFImageEditorDelegate> delegate;

- (void)reset:(BOOL)animated;

@end


