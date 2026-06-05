allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    // Workaround for older Flutter plugins (e.g. device_calendar 3.9.0) that declare
    // their package only in AndroidManifest.xml and not as a `namespace`, which AGP 8+
    // requires. Inject the manifest package as the namespace when one is missing.
    // Registered before evaluationDependsOn so it runs while the project is still configurable.
    afterEvaluate {
        val androidExtension = extensions.findByName("android")
        if (androidExtension is com.android.build.gradle.BaseExtension) {
            if (androidExtension.namespace == null) {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val pkg = Regex("package=\"([^\"]+)\"")
                        .find(manifestFile.readText())
                        ?.groupValues
                        ?.get(1)
                    if (pkg != null) {
                        androidExtension.namespace = pkg
                    }
                }
            }
            // Align Java/Kotlin JVM targets for old plugins (e.g. device_calendar)
            // that don't set compileOptions, avoiding AGP 8's inconsistent-target error.
            // Use 1.8 so the plugin's low compileSdk (29) stays valid.
            if (project.name == "device_calendar") {
                androidExtension.compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_1_8
                    targetCompatibility = JavaVersion.VERSION_1_8
                }
                tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                    compilerOptions {
                        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
                    }
                }
            }
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
