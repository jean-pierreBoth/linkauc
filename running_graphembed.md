Run graphembed on any moder Linux systems

```bash
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.1/graphembed_Linux_x86-64_v0.1.1.zip
unzip graphembed_Linux_x86-64_v0.1.1.zip
chmod a+x graphembed
wget https://github.com/jianshu93/graphembed/releases/download/v0.1.1/BlogCatalog.txt

### use NodeSketch method
RUST_LOG=info ./graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1 --skip 0.2 --centric sketching --symetric --dim 1000 --decay 0.5 --nbiter 5
### use HOPE method
RUST_LOG=info ./graphembed --csv ./BlogCatalog.txt --symetric true validation --nbpass 1 --skip 0.2 --centric hope precision --epsil 0.5 --maxrank 400 --blockiter 5
```
