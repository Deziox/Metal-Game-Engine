#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position;
    float4 color;
};

struct RasterizerData{
    float4 position [[ position ]];
    float4 color;
};

vertex RasterizerData basic_vertex_shader(device VertexIn *vertices [[ buffer(0) ]],uint vertexID [[ vertex_id ]]){
    RasterizerData rd;
    float x = vertices[vertexID].position[0];
    float y = vertices[vertexID].position[1];
    rd.position = float4(x,y,0,1);
    rd.color = vertices[vertexID].color;
    return rd;
}

fragment float4 basic_fragment_shader(RasterizerData rd [[ stage_in ]]){
    float4 position = rd.position;
    float dist = distance(normalize(position),float4(0.0,0.0,0.0,1.0));
    float4 color = rd.color;
    
    return float4(color[0],color[1],color[2],1);
}
