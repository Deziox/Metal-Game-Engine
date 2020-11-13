#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
};

vertex RasterizerData basic_vertex_shader(const VertexIn vin [[ stage_in ]]){
    RasterizerData rd;
    float x = vin.position[0];
    float y = vin.position[1];
    rd.position = float4(x,y,0,1);
    rd.color = vin.color;
    return rd;
}

fragment float4 basic_fragment_shader(RasterizerData rd [[ stage_in ]]){
    float4 position = rd.position;
    float dist = distance(normalize(position),float4(0.0,0.0,0.0,1.0));
    float4 color = rd.color;
    
    return float4(color[0],color[1],color[2],1);
}
