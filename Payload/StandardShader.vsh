//
//  Shader.vsh
//  Ions
//
//  Created by Douglas Applewhite on 4/5/10.
//  Copyright Douglas Applewhite 2010. All rights reserved.
//

uniform mat3 u_matTransformation;
uniform vec3 u_vecTranslation;
uniform vec2 u_vWindowSize;

attribute vec3 position;
attribute vec2 textureCoords;

varying vec2 textureVarying;

void main()
{
   vec3 transformedPosition = u_matTransformation * position + u_vecTranslation;
   float aspectRecip = u_vWindowSize.y / u_vWindowSize.x;
   
   gl_Position.x = 2.0*transformedPosition.x - 1.0;
   gl_Position.y = 2.0*transformedPosition.y/aspectRecip - 1.0;
   gl_Position.z = 0.0;
   gl_Position.w = 1.0;
   
   textureVarying = textureCoords;
}
