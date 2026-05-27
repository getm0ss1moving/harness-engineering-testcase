package com.example.app.architecture;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;
import org.springframework.beans.factory.annotation.Autowired;

import static com.tngtech.archunit.core.domain.AccessTarget.Predicates.declaredIn;
import static com.tngtech.archunit.core.domain.JavaCall.Predicates.target;
import static com.tngtech.archunit.core.domain.properties.HasName.Predicates.name;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.fields;
import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;
import static com.tngtech.archunit.library.Architectures.layeredArchitecture;

@AnalyzeClasses(packages = "com.example.app", importOptions = ImportOption.DoNotIncludeTests.class)
class ArchitectureConstraintsTest {

    @ArchTest
    static final ArchRule layered = layeredArchitecture()
            .consideringAllDependencies()
            .optionalLayer("Controller").definedBy("..controller..")
            .optionalLayer("Service").definedBy("..service..")
            .optionalLayer("Mapper").definedBy("..mapper..")
            .optionalLayer("Domain").definedBy("..domain..")
            .whereLayer("Controller").mayNotBeAccessedByAnyLayer()
            .whereLayer("Service").mayOnlyBeAccessedByLayers("Controller")
            .whereLayer("Mapper").mayOnlyBeAccessedByLayers("Service")
            .as("架构分层违规！Controller 严禁越级直接访问 Mapper。✅ FIX: 必须经由 Service 层。");

    @ArchTest
    static final ArchRule noJavaxPackages = noClasses()
            .should().dependOnClassesThat().resideInAnyPackage("javax..")
            .allowEmptyShould(true)
            .as("严禁使用 javax.* 包。✅ FIX: Spring Boot 3.5 必须全面使用 jakarta.* 规范。");

    @ArchTest
    static final ArchRule noSystemOutPrintln = noClasses()
            .should().callMethodWhere(target(declaredIn("java.io.PrintStream").and(name("println"))))
            .allowEmptyShould(true)
            .as("禁止 System.out.println。✅ FIX: 请使用 SLF4J Logger。");

    @ArchTest
    static final ArchRule noNakedHttpClients = noClasses()
            .should().dependOnClassesThat().haveFullyQualifiedName("org.springframework.web.client.RestTemplate")
            .orShould().dependOnClassesThat().haveFullyQualifiedName("java.net.HttpURLConnection")
            .allowEmptyShould(true)
            .as("禁止裸 RestTemplate / HttpURLConnection。✅ FIX: 请统一通过 ApiClient 抽象发起 HTTP 调用。");

    @ArchTest
    static final ArchRule noFieldInjection = fields()
            .that().areDeclaredInClassesThat().resideInAnyPackage("..service..", "..controller..")
            .should().notBeAnnotatedWith(Autowired.class)
            .allowEmptyShould(true)
            .as("禁止字段级 @Autowired 注入。✅ FIX: 请使用构造器注入 (Constructor Injection)。");

    @ArchTest
    static final ArchRule domainDtoMustBeRecords = classes()
            .that().resideInAPackage("..domain.dto..")
            .should().beRecords()
            .allowEmptyShould(true)
            .as("Domain 下的 DTO 必须使用 Java 25 record 以确保不可变性。✅ FIX: 请改为 record。");
}
