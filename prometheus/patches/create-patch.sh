wget https://raw.githubusercontent.com/prometheus/prometheus/release-2.34/go.mod

 2007  diff -u old.go new.go > reflect_unsafe_type.patch
 2015  diff -u go.mod.old go.mod > go.mod.patch

 2029  git clone https://github.com/modern-go/reflect2.git -b v1.0.2
 2030  cd reflect2/
 2031  cd ..
 2032  mv reflect2/ patches
 2033  cd patche
 2034  cd patches
 2035  ls
 2036  patch -u -b reflect2/unsafe_type.go -i reflect_unsafe_type.patch
