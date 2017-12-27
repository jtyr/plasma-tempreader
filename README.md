plasma-tempreader
=================

Plasma 5 widget to read temperature from DS18B20 sensor via [RESTful
API](https://github.com/jtyr/tempreader).

![Demo](https://raw.githubusercontent.com/jtyr/plasma-tempreader/master/images/demo.gif "Demo")


Installation
------------

```
cd build
cmake -DCMAKE_INSTALL_PREFIX=~/.local ..
make
make install

# Uninstall:
xargs rm < install_manifest.txt
```

License
-------

MIT


Author
------

Jiri Tyr
