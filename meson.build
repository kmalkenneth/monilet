
project('com.github.kmal-kenneth.monilet', 'vala', 'c', version: '0.1.8')

gnome = import('gnome')
i18n = import('i18n')

conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
    '-include', 'config.h',
    '-w'
]

asresources = gnome.compile_resources(
    'as-resources', 'data/' + meson.project_name() + '.gresource.xml',
    source_dir: 'data',
    c_name: 'as'
)

executable(
    meson.project_name(),
    asresources,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Widgets/WidgetCpu.vala',
    'src/Widgets/WidgetMemory.vala',
    'src/Services/CPU.vala',
    'src/Services/Memory.vala',
    'src/Utils/UtilsWidget.vala',

    c_args: c_args,
    dependencies: [
        dependency('glib-2.0'),
        dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('gobject-2.0'),
        dependency('libgtop-2.0'),
        dependency('cairo'),
        meson.get_compiler('c').find_library('m', required : false),
        meson.get_compiler('vala').find_library('posix')
    ],
    vala_args: [
        '--vapidir=' + meson.source_root() + '/vapi/',
    ],
    install: true,
)

# Add in a post install script
meson.add_install_script('meson/post_install.py')

subdir('data')
subdir('po')
