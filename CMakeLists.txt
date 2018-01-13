    # project name
    project (com.github.kmal-kenneth.monilet)

    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.kmal-kenneth.monilet")

    set (EXEC_NAME "com.github.kmal-kenneth.monilet")
    set (RELEASE_NAME "A system monitor applet.")
    set (VERSION "0.4")
    set (VERSION_INFO "Initial verion.")

    # we're about to use pkgconfig to make sugiyre dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)
    
    set (MONITOR_DEPS
        gtk+-3.0
        granite
        glib-2.0
        cairo
    )

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED ${MONITOR_DEPS})
    
    add_definitions(${DEPS_CFLAGS})
    link_libraries(${DEPS_LIBRARIES})
    link_directories(${DEPS_LIBRARY_DIRS})
    
    # Comment this out to enable C compiler warnings
    add_definitions (-w)
    add_definitions ("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"" -DWNCK_I_KNOW_THIS_IS_UNSTABLE)

    # add the directory of gtop for bindigs
    link_libraries(${WNCK_LIBRARIES} gtop-2.0 -lm)
    include_directories(/usr/include/libgtop-2.0)

    # make sure we have vala
    find_package(Vala REQUIRED)
    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/Application.vala
        src/MainWindow.vala
        
        src/Widgets/WidgetCpu.vala
        src/Widgets/WidgetMemory.vala
        
        src/Services/CPU.vala
        src/Services/Memory.vala
 
        src/Utils/UtilsWidget.vala

        # tell what libraries to use when compiling
        PACKAGES
            ${MONITOR_DEPS}
            posix
        # tell what libraries to use when compiling
        CUSTOM_VAPIS
            vapi/libgtop-2.0.vapi
        OPTIONS
            --thread
            --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
    )
    
    # add GResource for css style
    include (GResource)
    glib_compile_resources (GLIB_RESOURCES_CSS SOURCE data/com.github.kmal-kenneth.monilet.gresource.xml)
    
    include (GSettings)
    add_schema ("data/com.github.kmal-kenneth.monilet.gschema.xml")
    
    # Translation files
    set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
    add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
    add_subdirectory (po)
    
    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C} ${GLIB_RESOURCES_CSS})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

    # install our .desktop file so the Applications menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.kmal-kenneth.monilet.desktop DESTINATION ${DATADIR}/applications/)

    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.kmal-kenneth.monilet.appdata.xml DESTINATION ${DATADIR}/metainfo/)
    
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.kmal-kenneth.monilet.svg"
  DESTINATION share/icons/hicolor/scalable/apps)
    
