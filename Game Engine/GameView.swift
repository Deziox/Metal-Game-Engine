import MetalKit;

class GameView: MTKView {

    var commandQueue :MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    let vertices: [SIMD3<Float>] = [
        SIMD3<Float>(0,1,0),
        SIMD3<Float>(-1,-1,0),
        SIMD3<Float>(1,-1,0)
    ]
    
    var currentTime = 0;
    
    var vertexBuffer: MTLBuffer!
    var fragmentBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder:coder)
        self.device = MTLCreateSystemDefaultDevice()
        self.clearColor = MTLClearColor(red: 0.43, green: 0.73, blue: 0.35, alpha: 1.0)
        self.colorPixelFormat = .bgra8Unorm
        self.commandQueue = device?.makeCommandQueue();
        
        createRenderPipelineState();
        
        createBuffers();
    }
    
    func createBuffers(){
        vertexBuffer = self.device?.makeBuffer(bytes: vertices, length: MemoryLayout<SIMD3<Float>>.stride*vertices.count, options: [])
        fragmentBuffer = self.device?.makeBuffer(bytes: <#T##UnsafeRawPointer#>, length: <#T##Int#>, options: <#T##MTLResourceOptions#>)
    }
    
    func createRenderPipelineState(){
        let library = self.device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = self.colorPixelFormat
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do{
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError{
            print(error)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else {return}
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        //send info to render command encoder
        renderCommandEncoder?.setVertexBuffer(vertexBuffer,offset: 0,index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.setFragmentBuffer(<#T##buffer: MTLBuffer?##MTLBuffer?#>, offset: <#T##Int#>, index: <#T##Int#>)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
