#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex_shader(device float3 *vertices [[ buffer(0) ]],uint vertexID [[ vertex_id ]]){
    //return float4(1,0,1,1);
    float3 d = vertices[vertexID];
    return float4(vertices[vertexID] , 1);
}

fragment float4 basic_fragment_shader(){
    return float4(1,0,1,1);
}
