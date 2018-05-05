package;

import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Shaders;
import kha.graphics4.FragmentShader;
import kha.graphics4.IndexBuffer;
import kha.graphics4.PipelineState;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;

class TextureDraw {
	static var pipeline: PipelineState;
	static var vertices: VertexBuffer;
	static var indices: IndexBuffer;
	static var texunit: kha.graphics4.TextureUnit;
	static var offset: kha.graphics4.ConstantLocation;

	public static function init() {				
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float3);
		structure.add("tex", VertexData.Float2);
		
		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.texture_vert;
		pipeline.fragmentShader = Shaders.texture_frag;
		pipeline.compile();
		
		texunit = pipeline.getTextureUnit("texsampler");
		offset = pipeline.getConstantLocation("mvp");

		vertices = new VertexBuffer(4, structure, Usage.StaticUsage);
		var v = vertices.lock();
		v.set(0, -1.0); v.set(1, -1.0); v.set(2, 0.5); v.set(3, 0.0); v.set(4, 1.0);
		v.set(5, 1.0); v.set(6, -1.0); v.set(7, 0.5); v.set(8, 1.0); v.set(9, 1.0);
		v.set(10, -1.0); v.set(11, 1.0); v.set(12, 0.5); v.set(13, 0.0); v.set(14, 0.0);
		v.set(15, 1.0); v.set(16, 1.0); v.set(17, 0.5); v.set(18, 1.0); v.set(19, 0.0);
		vertices.unlock();
		
		indices = new IndexBuffer(6, Usage.StaticUsage);
		var i = indices.lock();
		i[0] = 0; i[1] = 1; i[2] = 2; i[3] = 1; i[4] = 3; i[5] = 2;
		indices.unlock();
	}

	public static function image(frame: Framebuffer, texture: Image) {
		var g = frame.g4;
		g.begin();
		g.clear(Color.Black);

		g.setPipeline(pipeline);
		g.setMatrix(offset, FastMatrix4.rotationZ(0));
		g.setTexture(texunit, texture);
		g.setVertexBuffer(vertices);
		g.setIndexBuffer(indices);
		g.drawIndexedVertices();
			
		g.end();
	}
}
