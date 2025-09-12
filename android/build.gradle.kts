plugins {
    // vazio no root
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Centraliza a saída em ../build (nível acima de android/)
layout.buildDirectory.set(layout.projectDirectory.dir("../build"))
subprojects {
    // Cada subprojeto grava em ../build/
    layout.buildDirectory.set(
        rootProject.layout.buildDirectory.dir(name)
    )
}

// Compatibilidade com tasks que dependem do :app
gradle.beforeProject {
    if (name != "app") {
        project.evaluationDependsOn(":app")
    }
}

tasks.register("clean") {
    delete(layout.buildDirectory)
}
