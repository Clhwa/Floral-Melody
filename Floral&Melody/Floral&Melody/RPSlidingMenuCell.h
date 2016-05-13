
#import <UIKit/UIKit.h>
/**
 The height of a RPSlidingCell when it is at it's full feature height.
 */
extern const CGFloat RPSlidingCellFeatureHeight;

/**
 The height of a RPSlidingCell when it is at it's normal height.
 */
extern const CGFloat RPSlidingCellCollapsedHeight;

/**
 RPSlidingMenu is a subclass of UICollectionViewCell that is used for displaying rows in a RPSlidingMenuViewController.  It has a textLabel that can be set to show a header title for the cell.  It also has a detailTextLabel where a longer description can follow the textLabel header.  The backgroundImageView allows an image to be set behind it.  This cell has text that fades and shrink as it goes from feature height to normal height
 */
@interface RPSlidingMenuCell : UICollectionViewCell

/**
 The topmost centered label that is used like a header for the cell.  The label grows as it approaches feature height
 */
@property (strong, nonatomic) UILabel *textLabel;

/**
 The bottommost centered label that is used for a description for the cell.  The label fades in as it approaches feature height
 */
@property (strong, nonatomic) UILabel *detailTextLabel;

/**
 The background image view of the cell.  Set this to supply an image that is centered in the cell. It is covered by a black view that has varying alpha depending on the cell size.
 */
@property (strong, nonatomic) UIImageView *backgroundImageView;

@end
