let project = new Project('ComputeShader');

project.addSources('Sources');

project.addShaders('Sources/Shaders/**');

project.addAssets('Assets/**');

resolve(project);
