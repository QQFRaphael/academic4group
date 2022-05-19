# BJANC编译

BJANC的编译主要分成两步，第一步是编译需要的lib，第二步是编译需要的bin

## libs编译

进入libs目录下，可以看到下面这些文件夹

| libadvect.a     | libdataport.a   | libdsserver.a | libfcolide.a | libgrib.a      | libmdv.a     |
| --------------- | --------------- | ------------- | ------------ | -------------- | ------------ |
| libcdata_util.a | libdidss.a      | libeispack.a  | libfftpack.a | libguidexv.a   | libMdv.a     |
| libcn.a         | libdsdata.a     | libeuclid.a   | libFmq.a     | libguidexv-c.a | libmm5.a     |
| libncf.a        | libphysics.a    | librapplot.a  | libsymprod.a | libtitan.a     | libxview.a   |
| libolgx.a       | librapformats.a | libshapelib.a | libtdrp.a    | libtoolsa.a    | libxview-c.a |
| libolgx-c.a     | librapmath.a    | libSpdb.a     | libtetwws.a  | libtrmm_rsl.a  | perl5        |
| python          |                 |               |              |                |              |

编译后的lib和这些文件夹的名字对应。如果编译不成功，可以进入到对应目录下手动编译

执行`make install`进行编译，编译完成后一共应该有37个lib文件在lib目录下

气科所的机器上通过`make install`能够编译完成30个，缺少7个，这7个需要手动进入目录编译，lib和对应的libs目录源代码文件夹如下：

| libs源代码目录 | 对应lib        |
| -------------- | -------------- |
| devguide       | libguidexv.a   |
| devguide-c     | libguidexv-c.a |
| eispack        | libeispack.a   |
| fcolide        | libfcolide.a   |
| grib           | libgrib.a      |
| ncf            | libncf.a       |
| tools/fftpack5 | libfftpack.a   |

注意，fftpack5编译完成后需要手动`mv`到lib目录下

## apps编译

进入apps目录下，可以看到下面这些文件夹

| adjoint    | colide_old  | ingest         | nowcast       | scripts_old        |
| ---------- | ----------- | -------------- | ------------- | ------------------ |
| awc        | dealias     | ingestBeijing  | physics       | spdb_utils         |
| blending   | didss       | ingestZhejiang | procmap       | tdrp               |
| cidd       | dsserver    | interp         | vdrasPP4wrfDA | titan              |
| cidd_old   | fgao_test   | lytest         | rucApps       | titan_analysis     |
| climo      | filters     | Makefile       | satApps       | titan_analysis_old |
| colide     | fuzzy_logic | mdv_utils      | satApps2      | titan_old          |
| colide_all | hydro       | mm5            | scripts       | trec               |

编译后的lib和这些文件夹的名字对应。如果编译不成功，可以进入到对应目录下手动编译

执行`make install`进行编译，编译完成后一共应该有203个可执行文件在bin目录下

气科所的机器上通过`make install`能够编译完成194个，但这当中，`ltgSpdb2GenPt`这个可执行文件之前没有编译出来但是现在编译出来了。所以实际缺少10个，这10个需要手动进入目录编译。可执行文件和对应的apps目录源代码文件夹如下：

| 可执行文件           | 源代码目录                |
| -------------------- | ------------------------- |
| ApFilter             | apps/filters/src/ApFilter |
| fos_ingest           | apps/awc/src/scripts      |
| ingest_awc_ac        |                           |
| ingest_awc_gif       |                           |
| ingest_awc_text      |                           |
| ingest_goes_mdv      |                           |
| pull_ruc_data        |                           |
| push_awc_area_files  |                           |
| push_awc_ascii_files |                           |

注意，`ltgSpdb2GenPt`这个可执行文件对应的源代码在`apps/didss/src/ltgSpdb2GenPt`目录下

在青山湖机器上编译时，还多出几个文件无法编译

| 可执行文件      | 源代码目录                      |
| --------------- | ------------------------------- |
| Dsr2Vol         | apps/didss/src/Dsr2Vol          |
| Fmq2Fmq         | apps/didss/src/Fmq2Fmq          |
| GenPoly2Mdv     | apps/spdb_utils/src/GenPoly2Mdv |
| InputWatcher    | apps/didss/src/InputWatcher     |
| Janitor         | apps/didss/src/Janitor          |
| kavltg2spdb     | apps/didss/src/kavltg2spdb      |
| LdataFMQtrigger | apps/didss/src/LdataFMQtrigger  |
| LdataWatcher    | apps/didss/src/LdataWatcher     |
| LdataWriter     | apps/didss/src/LdataWriter      |
| Mdv2Dsr         | apps/didss/src/Mdv2Dsr          |
| RadMon          | apps/didss/src/RadMon           |
| RateOfChange    | apps/satApps/src/RateOfChange   |
| Scout           | apps/didss/src/Scout            |
| Validator       | apps/didss/src/Validator        |

