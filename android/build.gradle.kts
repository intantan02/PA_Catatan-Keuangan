allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Hapus pengaturan buildDirectory custom yang tidak kompatibel dengan Android Gradle Plugin

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}