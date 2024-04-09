../tinytapeout_gds_viewer/out.gltf: runs/tt/final/gds/tt_um_kovirobi_bsv_test.gds
	gds2gltf $< $@

runs/tt/final/gds/tt_um_kovirobi_bsv_test.gds: src/tt_um_kovirobi_bsv_test.v
	openlane --pdk-root ../volare --pdk sky130B config.json --run-tag tt

src/%.svg: src/%.json
	netlistsvg $< -o $@

src/%.json: bsv/%.bsv
	yosys -p "plugin -i bluespec; read_bluespec -top $* $<; prep; write_json $@"

src/%.v: bsv/%.bsv
	yosys -p "plugin -i bluespec; read_bluespec -top $* $<; prep; write_verilog $@"
