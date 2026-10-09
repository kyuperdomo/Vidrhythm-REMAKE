//
//  Shader.fsh
//  Ions
//
//  Created by Douglas Applewhite on 4/5/10.
//  Copyright Douglas Applewhite 2010. All rights reserved.
//
precision mediump float;

varying lowp vec2 textureVarying;

uniform sampler2D u_texture;

void main()
{
   gl_FragColor = texture2D( u_texture, textureVarying );
}
