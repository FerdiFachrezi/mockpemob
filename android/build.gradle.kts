// FILE: android/build.gradle.kts

// --- BAGIAN INI YANG HILANG SEBELUMNYA ---
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Ini adalah "alat" untuk membaca google-services.json
        classpath("com.google.gms:google-services:4.4.0")
    }
}
// ------------------------------------------

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}