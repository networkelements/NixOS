$ python build_mozc.py gyp
INFO: Generating version definition file...
INFO: Version string is 1.6.1187.102
INFO: Running: /run/current-system/sw/bin/python /home/neko/src/mozc/src/build_tools/ensure_gyp_module_path.py --expected=/home/neko/src/mozc/src/third_party/gyp/pylib/gyp
INFO: Copying file to: third_party/rx/rx.gyp
INFO: Copying file to: third_party/jsoncpp/jsoncpp.gyp
INFO: Build tool: make
INFO: Running: pkg-config --exists ibus-1.0 >= 1.4.1
Traceback (most recent call last):
  File "build_mozc.py", line 1442, in <module>
    main()
  File "build_mozc.py", line 1424, in main
    GypMain(cmd_opts, cmd_args)
  File "build_mozc.py", line 603, in GypMain
    gyp_file_names = GetGypFileNames(options)
  File "build_mozc.py", line 214, in GetGypFileNames
    if not PkgExists('ibus-1.0 >= 1.4.1'):
  File "build_mozc.py", line 163, in PkgExists
    RunOrDie(command_line)
  File "/home/neko/src/mozc/src/build_tools/util.py", line 90, in RunOrDie
    process = subprocess.Popen(argv)
  File "/nix/store/wgpm4zx4acdyyrbsn2f6kkfwdmbydplf-python-2.7.3/lib/python2.7/subprocess.py", line 679, in __init__
    errread, errwrite)
  File "/nix/store/wgpm4zx4acdyyrbsn2f6kkfwdmbydplf-python-2.7.3/lib/python2.7/subprocess.py", line 1249, in _execute_child
    raise child_exception
OSError: [Errno 2] No such file or directory
