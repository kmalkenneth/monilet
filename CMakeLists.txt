  # project name
  project (com.github.kmal-kenneth.monilet)

  # the oldest stable cmake version we support
  cmake_minimum_required (VERSION 2.6)

  # tell cmake where its modules can be found in our project directory
  list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
  list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)
  
  # tell cmake uninstall modules
  configure_file (
      "${CMAKE_SOURCE_DIR}/cmake/Uninstall.cmake"
      "${CMAKE_CURRENT_BINARY_DIR}/Uninstall.cmake"
      IMMEDIATE @ONLY)  
  add_custom_target (uninstall
      COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/Uninstall.cmake)

  # where we install data directory (if we have any)
  set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

  # what to call that directory where we install data too
  set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")

  set (EXEC_NAME ${CMAKE_PROJECT_NAME})
  set (RELEASE_NAME "A system monitor applet")
  set (VERSION "0.1.8")
  set (VERSION_INFO "See percentage of use your CPU and number of cores. Also percentage used memory, amount of memory used and total memory.")
  
  # enable testing
  enable_testing (true)
  
  # disable C compiler warnings
  add_definitions(-w)

  # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
  find_package(PkgConfig)

  # now let's actually check for the required dependencies
  set (DEPENDENCIES 
        glib-2.0 
        gobject-2.0 
        gtk+-3.0 
        granite 
        cairo
      )
  pkg_check_modules(DEPS REQUIRED ${DEPENDENCIES})

  add_definitions(${DEPS_CFLAGS})
  link_libraries(${DEPS_LIBRARIES})
  link_directories(${DEPS_LIBRARY_DIRS})

  # make sure we have vala
  find_package(Vala REQUIRED)
  # make sure we use vala
  include(ValaVersion)
  # make sure it's the desired version of vala
  ensure_vala_version("0.16" MINIMUM)
  
  # add the directory of gtop for bindigs
  link_libraries(${WNCK_LIBRARIES} gtop-2.0 -lm)
  include_directories(/usr/include/libgtop-2.0)

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
      ${DEPENDENCIES}
      
  # tell what libraries to use when compiling
  CUSTOM_VAPIS
     vapi/libgtop-2.0.vapi
     
  # Set compilation options
  OPTIONS
     --vapidir=${CMAKE_CURRENT_SOURCE_DIR}/vapi/
     --debug
  )
  
  # install our .gresource.xml file to access our resources
  include (GResource)
  glib_compile_resources (GLIB_RESOURCES SOURCE data/${CMAKE_PROJECT_NAME}.gresource.xml)

  # tell cmake what to call the executable we just made
  add_executable(${EXEC_NAME} ${VALA_C} ${GLIB_RESOURCES})

  # install the binaries we just made
  install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)

  # install our .desktop file so the Applications menu will see it
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/${CMAKE_PROJECT_NAME}.desktop DESTINATION ${DATADIR}/applications/)

  # install our .appdata.xml file so AppCenter will see it
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/${CMAKE_PROJECT_NAME}.appdata.xml DESTINATION ${DATADIR}/metainfo/)
  
  # install our .gschema.xml file to save the status of our application
  include (GSettings)
  add_schema ("data/${CMAKE_PROJECT_NAME}.gschema.xml")
  
  # install our icons to see our application anywhere    
  #install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/16/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/16x16/apps)
  #install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/24/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/24x24/apps)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/32/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/32x32/apps)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/48/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/48x48/apps)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/64/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/64x64/apps)
  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/icons/128/${CMAKE_PROJECT_NAME}.svg" DESTINATION ${DATADIR}/icons/hicolor/128x128/apps)
  
  # install our images to see our application   
  #install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/${CMAKE_PROJECT_NAME}.svg" DESTINATION "${DATADIR}/base/images")
  #install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/images/${CMAKE_PROJECT_NAME}.png" DESTINATION "${DATADIR}/pixmaps")
  
  # translation files
  set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")
  add_definitions (-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
  add_subdirectory (po)
  
  
  
