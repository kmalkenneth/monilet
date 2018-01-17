project('com.github.kmal-kenneth.monilet','c', 'vala',
  version: '0.1.0',
  meson_version: '>= 0.40.0',
)

i18n = import('i18n')
gnome = import('gnome')

# build
sources = [
  'src/Application.vala',
  'src/MainWindow.vala',
  'src/Widgets/WidgetCpu.vala',
  'src/Widgets/WidgetMemory.vala',
  'src/Services/CPU.vala',
  'src/Services/Memory.vala',
  'src/Utils/UtilsWidget.vala',
]

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')
add_global_arguments('-DGETTEXT_PACKAGE="com.github.kmal-kenneth.monilet"', language:'c')

deps = [
  dependency('gtk+-3.0'),
  dependency('granite'),
  dependency('glib-2.0'),
  dependency('gobject-2.0'),
  dependency('cairo'),
  dependency('libgtop-2.0'),
  meson.get_compiler('c').find_library('m', required : false)
]

sources += gnome.compile_resources('as-resources',
  'data/com.github.kmal-kenneth.monilet.gresource.xml',
  source_dir: 'data',
  c_name: 'as'
)

executable('com.github.kmal-kenneth.monilet', sources,
  vala_args: '--target-glib=2.50',
  dependencies: deps,
  install: true,
)

subdir('data')
# subdir('src')
subdir('po')

meson.add_install_script('meson/postinstall.py')


