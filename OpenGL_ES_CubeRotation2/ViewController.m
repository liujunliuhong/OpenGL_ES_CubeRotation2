//
//  ViewController.m
//  OpenGL_ES_CubeRotation2
//
//  Created by apple on 2020/7/28.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>

#define kCoodinateCount    36

typedef struct {
    GLKVector3 positionCoodinate; // 顶点坐标
    GLKMatrix2 textureCoodinate; // 纹理坐标
    GLKVector3 normal; // 法线(光照)
} MyVertex;



@interface ViewController () <GLKViewDelegate> {
    GLuint _bufferID;
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKView *glkView;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, assign) MyVertex *vetrexs;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSInteger angle;
@end

@implementation ViewController

- (void)dealloc{
    if ([EAGLContext currentContext] == self.glkView.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    if (self.vetrexs) {
        free(self.vetrexs);
        self.vetrexs = nil;
    }
    
    if (_bufferID) {
        glDeleteBuffers(1, &_bufferID);
        _bufferID = 0;
    }
    
    [self.displayLink invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self setupConfig];
    [self setupVertexData];
    [self setupTexture];
    [self addDisplayLink];
}

// 配置基本信息
- (void)setupConfig{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    // 判断是否创建成功
    if (!self.context) {
        NSLog(@"Create ES context failed");
        return;
    }
    
    // 设置当前上下文
    [EAGLContext setCurrentContext:self.context];
    
    // GLKView
    CGRect frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 20 * 2, [UIScreen mainScreen].bounds.size.height - 100 * 2);
    self.glkView = [[GLKView alloc] initWithFrame:frame context:self.context];
    self.glkView.delegate = self;
    self.glkView.context = self.context;
    
    self.glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [self.view addSubview:self.glkView];
    
    glClearColor(0.5, 0.5, 0.5, 1);
}

// 配置顶点数据
- (void)setupVertexData{
    // 开辟空间
    self.vetrexs = malloc(sizeof(MyVertex) * kCoodinateCount);
    
    // 前面
    self.vetrexs[0] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 0, 1}};
    self.vetrexs[1] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    self.vetrexs[2] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    self.vetrexs[3] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    self.vetrexs[4] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    self.vetrexs[5] = (MyVertex){{0.5, -0.5, 0.5}, {1, 0}, {0, 0, 1}};
    
    // 上面
    self.vetrexs[6] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 1, 0}};
    self.vetrexs[7] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    self.vetrexs[8] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    self.vetrexs[9] = (MyVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    self.vetrexs[10] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    self.vetrexs[11] = (MyVertex){{-0.5, 0.5, -0.5}, {0, 0}, {0, 1, 0}};
    
    // 下面
    self.vetrexs[12] = (MyVertex){{0.5, -0.5, 0.5}, {1, 1}, {0, -1, 0}};
    self.vetrexs[13] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    self.vetrexs[14] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    self.vetrexs[15] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    self.vetrexs[16] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    self.vetrexs[17] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, -1, 0}};
    
    // 左面
    self.vetrexs[18] = (MyVertex){{-0.5, 0.5, 0.5}, {1, 1}, {-1, 0, 0}};
    self.vetrexs[19] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    self.vetrexs[20] = (MyVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    self.vetrexs[21] = (MyVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    self.vetrexs[22] = (MyVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    self.vetrexs[23] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {-1, 0, 0}};
    
    // 右面
    self.vetrexs[24] = (MyVertex){{0.5, 0.5, 0.5}, {1, 1}, {1, 0, 0}};
    self.vetrexs[25] = (MyVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    self.vetrexs[26] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    self.vetrexs[27] = (MyVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    self.vetrexs[28] = (MyVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    self.vetrexs[29] = (MyVertex){{0.5, -0.5, -0.5}, {0, 0}, {1, 0, 0}};
    
    // 后面
    self.vetrexs[30] = (MyVertex){{-0.5, 0.5, -0.5}, {0, 1}, {0, 0, -1}};
    self.vetrexs[31] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    self.vetrexs[32] = (MyVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    self.vetrexs[33] = (MyVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    self.vetrexs[34] = (MyVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    self.vetrexs[35] = (MyVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, 0, -1}};
    
    
    glGenBuffers(1, &_bufferID); // 开辟1个顶点缓冲区，所以传入1
    NSLog(@"bufferID:%d", _bufferID);
    // 绑定顶点缓冲区
    glBindBuffer(GL_ARRAY_BUFFER, _bufferID);
    // 缓冲区大小
    GLsizeiptr bufferSizeBytes = sizeof(MyVertex) * kCoodinateCount;
    // 将顶点数组的数据copy到顶点缓冲区中(GPU显存中)
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.vetrexs, GL_STATIC_DRAW);
    
    
    // 打开读取通道
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 顶点坐标数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(MyVertex)/*由于是结构体，所以步长就是结构体大小*/, NULL + offsetof(MyVertex, positionCoodinate));
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); // 纹理坐标数据
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(MyVertex), NULL + offsetof(MyVertex, textureCoodinate));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal); // 法线数据
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(MyVertex), NULL + offsetof(MyVertex, normal));
}

// 配置纹理
- (void)setupTexture{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    
    // 初始化纹理
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft: @(1)}; // 纹理坐标原点是左下角,但是图片显示原点应该是左上角
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    NSLog(@"textureInfo.name: %d", textureInfo.name);
    
    // 使用苹果`GLKit`提供的`GLKBaseEffect`完成着色器工作(顶点/片元)
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    self.baseEffect.light0.enabled = YES; // 开启光照效果
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1); // 开启漫反射
    self.baseEffect.light0.position = GLKVector4Make(-0.5, -0.5, 5, 1); // 光源位置
    
    // 透视投影矩阵
    CGFloat aspect = fabs(self.glkView.bounds.size.width / self.glkView.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0);
    self.baseEffect.transform.projectionMatrix = projectionMatrix;
}

// 添加定时器
- (void)addDisplayLink{
    self.angle = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScene)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// 更新
- (void)updateScene{
    // 角度变化
    self.angle = self.angle + 2;
    // 修改`baseEffect.transform.modelviewMatrix`
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4.0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(_angle), 0.3, 0.5, 0.7);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    // 重新渲染
    [self.glkView display];
}

#pragma mark GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    // 开启深度测试
    glEnable(GL_DEPTH_TEST);
    
    // 清除颜色缓冲区、深度缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // 准备绘制
    [self.baseEffect prepareToDraw];
    
    // 开始绘制
    glDrawArrays(GL_TRIANGLES, 0, kCoodinateCount); // 从第一个开始，所以是0
}
@end


