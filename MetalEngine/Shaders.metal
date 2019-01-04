//
//  Shaders.metal
//  MetalEngine
//
//  Created by Joon Hwa Jung on 1/3/19.
//  Copyright © 2019 Joon Hwa Jung. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float3 position [[attribute(0)]];
  float3 normal [[attribute(1)]];
  float2 texCoords [[attribute(2)]];
};

struct VertexOut {
  float4 position [[position]];
  float3 worldNormal;
  float3 worldPosition;
  float2 texCoords;
};

struct Uniforms {
  float4x4 modelMatrix;
  float4x4 viewProjectionMatrix;
  float3x3 normalMatrix;
};

vertex VertexOut vertex_main(VertexIn vertexIn [[stage_in]], constant Uniforms &uniforms [[buffer(1)]])
{
  float4 worldPosition = uniforms.modelMatrix * float4(vertexIn.position, 1);
  VertexOut vertexOut;
  vertexOut.position = uniforms.viewProjectionMatrix * worldPosition;
  vertexOut.worldNormal = uniforms.normalMatrix * vertexIn.normal;
  vertexOut.worldPosition = worldPosition.xyz;
  vertexOut.texCoords = vertexIn.texCoords;
  return vertexOut;
}

constant float3 ambientIntensity = 0.3;
constant float3 lightPosition(2, 2, 2);
constant float3 lightColor(1, 1, 1);
constant float3 worldCameraPosition(0, 0, 2);
constant float specularPower = 200;

fragment float4 fragment_main(VertexOut fragmentIn [[stage_in]], texture2d<float, access::sample> baseColorTexture [[texture(0)]], sampler baseColorSampler [[sampler(0)]])
{
  float3 baseColor = baseColorTexture.sample(baseColorSampler, fragmentIn.texCoords).rgb;
  float3 N = normalize(fragmentIn.worldNormal);
  float3 L = normalize(lightPosition - fragmentIn.worldPosition);
  float3 diffuseIntensity = saturate(dot(N, L));
  float3 V = normalize(worldCameraPosition - fragmentIn.worldPosition);
  float3 H = normalize(L + V);
  float specularBase = saturate(dot(N, H));
  float specularIntensity = powr(specularBase, specularPower);
  float3 finalColor = saturate(ambientIntensity + diffuseIntensity) * lightColor * baseColor + specularIntensity * lightColor;
  return float4(finalColor, 1);
}
