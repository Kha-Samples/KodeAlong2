package;

import kha.Assets;
import kha.Framebuffer;
import kha.Image;
import kha.compute.Compute;
import kha.compute.ConstantLocation;
import kha.compute.Shader;
import kha.compute.TextureUnit;
import kha.compute.Access;
import kha.graphics4.TextureFormat;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.Shaders;
import kha.System;

class Main {
	static var vertices: Array<Float>;
	static var texcoords: Array<Float>;
	static var indices: Array<Int>;

	static var computeTexunit: kha.compute.TextureUnit;
	static var p1: kha.compute.ConstantLocation;
	static var p2: kha.compute.ConstantLocation;
	static var p3: kha.compute.ConstantLocation;
	static var texture: Image;
	
	public static function main(): Void {
		System.init({title: "ComputeShader", width: 800, height: 600}, function () {
			Assets.loadEverything(function () {
				start();
				System.notifyOnRender(render);
			});
		});
	}

	static function start(): Void {
		var data = new OgexData(Assets.blobs.tiger_ogex.toString());
		vertices = data.geometryObjects[0].mesh.vertexArrays[0].values;
		texcoords = data.geometryObjects[0].mesh.vertexArrays[2].values;
		indices = data.geometryObjects[0].mesh.indexArray.values;

		TextureDraw.init();

		texture = Image.create(800, 600, TextureFormat.RGBA128);
		computeTexunit = Shaders.triangle_comp.getTextureUnit("destTex");
		p1 = Shaders.triangle_comp.getConstantLocation("p1");
		p2 = Shaders.triangle_comp.getConstantLocation("p2");
		p3 = Shaders.triangle_comp.getConstantLocation("p3");
	}
	
	static function render(frame: Framebuffer): Void {
		Compute.setShader(Shaders.clear_comp);
		Compute.setTexture(computeTexunit, texture, Access.Write);
		Compute.compute(texture.width, texture.height, 1);

		for (i in 0...200) { //Std.int(indices.length / 3)) {
			var i1 = indices[i * 3 + 0];
			var i2 = indices[i * 3 + 1];
			var i3 = indices[i * 3 + 2];
			
			var vec1 = new FastVector3(vertices[i1 * 3 + 0], vertices[i1 * 3 + 1], vertices[i1 * 3 + 2]);
			var tex1 = new FastVector2(texcoords[i1 * 2 + 0], texcoords[i1 * 2 + 1]);
			
			var vec2 = new FastVector3(vertices[i2 * 3 + 0], vertices[i2 * 3 + 1], vertices[i2 * 3 + 2]);
			var tex2 = new FastVector2(texcoords[i2 * 2 + 0], texcoords[i2 * 2 + 1]);
			
			var vec3 = new FastVector3(vertices[i3 * 3 + 0], vertices[i3 * 3 + 1], vertices[i3 * 3 + 2]);
			var tex3 = new FastVector2(texcoords[i3 * 2 + 0], texcoords[i3 * 2 + 1]);
			
			var scale = 128;
			var w = System.windowWidth();
			var h = System.windowHeight();
			//Triangles.draw(g, vec1.x * scale + w / 2, vec1.y * scale + h / 2, vec1.z, tex1.x, tex1.y,
			//					vec2.x * scale + w / 2, vec2.y * scale + h / 2, vec2.z, tex2.x, tex2.y,
			//					vec3.x * scale + w / 2, vec3.y * scale + h / 2, vec3.z, tex2.x, tex3.y);

			Compute.setShader(Shaders.triangle_comp);
			Compute.setTexture(computeTexunit, texture, Access.Write);
			Compute.setFloat2(p1, vec1.x * scale + w / 2, vec1.y * scale + h / 2);
			Compute.setFloat2(p2, vec2.x * scale + w / 2, vec2.y * scale + h / 2);
			Compute.setFloat2(p3, vec3.x * scale + w / 2, vec3.y * scale + h / 2);
			Compute.compute(texture.width, texture.height, 1);
		}

		TextureDraw.image(frame, texture);
	}
}
