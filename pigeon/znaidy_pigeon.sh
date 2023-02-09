flutter pub run pigeon \
 --input pigeon/znaidy_annotation.dart \
 --dart_out lib/src/pigeons/znaidy_annotation_messager.dart.orig \
 --java_package "com.mapbox.maps.pigeons" \
 --java_out android/src/main/java/com/mapbox/maps/pigeons/FLTZnaidyAnnotationMessager.java \
 --objc_prefix "FLT" \
 --objc_header_out ios/Classes/ZnaidyAnnotationMessager.h \
 --objc_source_out ios/Classes/ZnaidyAnnotationMessager.m
