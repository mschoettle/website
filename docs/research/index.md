# Research

In 2019, I completed a PhD under the supervision of [Jörg Kienzle](https://djeminy.github.io/).
I was working on [Concern-Oriented Reuse (CORE)](https://djeminy.github.io/portfolio/portfolio-1/), more specifically on bridging the gap between code and models.
<!-- markdownlint-disable-next-line link-fragments -->
My thesis (["Model-Based Reuse of Framework APIs: Bridging the Gap Between Models
and Code"](#paper-19)) aimed at making existing software frameworks reusable at the modelling level while at the same time exploiting the benefits that the higher level of abstraction provides.
This can also help users reusing those frameworks at the programming level.

During my PhD time, I was also the Lead Software Developer in the Software Engineering Laboratory (SEL) at McGill University (Montréal, Canada).
In this role, I helped build [TouchCORE](https://djeminy.github.io/touchcore/), a multitouch-enabled tool for agile concern-oriented software design modeling aimed at developing scalable and reusable software design models.

## Publications
<!-- markdownlint-disable no-empty-links -->
<!-- markdownlint-disable max-one-sentence-per-line -->
### 2019

- **Matthias Schöttle** and Jörg Kienzle. [On the Difficulties of Raising the Level of Abstraction and Facilitating Reuse in Software Modelling: The Case for Signature Extension](../assets/papers/mise-schoettle2019.pdf). In _Proceedings of the 11th International Workshop on Modelling in Software Engineering_, MiSE ’19, page 71–77, Piscataway, NJ, USA, 2019. IEEE Press. [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1109/MiSE.2019.00018 "View document on publisher site")
{ #paper-20 }

    !!! abstract hidden

        Reuse is central to improving the software development process, increasing software quality and decreasing time-to-market. Hence it is of paramount importance that modelling languages provide features that enable the specification and modularization of reusable artefacts, as well as their subsequent reuse. In this paper we outline several difficulties caused by the finality of method signatures that make it hard to specify and use reusable artefacts encapsulating several variants. The difficulties are illustrated with a running example. To evaluate whether these difficulties can be observed at the programming level, we report on an empirical study conducted on the Java Platform API as well as present workarounds used in various programming languages to deal with the rigid nature of signatures. Finally, we outline signature extension as an approach to overcome these problems at the modelling level.

    !!! cite hidden

        ```bibtex
        @InProceedings{MiSE/Schoettle2019,
            author = {Matthias Sch{\"{o}}ttle and J{\"{o}}rg Kienzle},
            title = {{On the Difficulties of Raising the Level of Abstraction and Facilitating Reuse in Software Modelling: The Case for Signature Extension}},
            booktitle = {Proceedings of the 11th International Workshop on Modelling in Software Engineering},
            year = {2019},
            series = {MiSE '19},
            pages = {71--77},
            address = {Piscataway, NJ, USA},
            publisher = {IEEE Press},
            abstract = {Reuse is central to improving the software development process, increasing software quality and decreasing time-to-market. Hence it is of paramount importance that modelling languages provide features that enable the specification and modularization of reusable artefacts, as well as their subsequent reuse. In this paper we outline several difficulties caused by the finality of method signatures that make it hard to specify and use reusable artefacts encapsulating several variants. The difficulties are illustrated with a running example. To evaluate whether these difficulties can be observed at the programming level, we report on an empirical study conducted on the Java Platform API as well as present workarounds used in various programming languages to deal with the rigid nature of signatures. Finally, we outline signature extension as an approach to overcome these problems at the modelling level.},
            doi = {10.1109/MiSE.2019.00018}
        }
        ```

- **Matthias Schöttle**. [_Model-Based Reuse of Framework APIs: Bridging the Gap Between Models and Code_](../assets/papers/phdthesis_schoettle2019.pdf). PhD thesis, School of Computer Science, McGill University, 2019.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[View Slides\]](../assets/papers/phdthesis_schoettle2019_slides.pdf "View Slides of presentation")
    { #paper-19 }

    !!! abstract hidden

        Reuse is considered key to software engineering and is very common at the implementation level. Many reusable libraries and frameworks exist and are widely reused. However, in the context of Model-Driven Engineering (MDE) reuse is not very common. Most modelling approaches do not support reuse, requiring a user to start their modelling activity either from scratch or copy and paste pieces from other models. This thesis provides a bridge for reusable units between implementation and modelling. We apply the principles of Concern-Oriented Reuse (CORE), a next-generation reuse technology, to lift existing frameworks up from the programming level to the modelling level. The level of abstraction of the API of existing frameworks is raised to the modelling level to facilitate their reuse within design models that are integrated within an MDE process. In addition, the benefits of the higher level of abstraction are exploited to formalize otherwise informally provided information, such as which features the framework provides, the impact of each feature on high-level goals and non-functional qualities, how to adapt the framework to the reuse context, and how the API of each feature is to be used. This thesis defines an automated algorithm that analyses the code of a framework and example code that uses the framework to produce an interface that 1) lists the user-perceivable features of the framework organized in a feature model, and 2) modularizes the API of the framework API according to each feature. The algorithm is implemented and validated on two small frameworks and the Android Notifications API along with an empirical user study. To smoothen the transition from a high-level abstraction to a low level of abstraction, i.e., from models to code, this thesis addresses the difficulty caused by the finality of signatures. We identify and discuss four difficult situations for defining high-level interfaces at the modelling level, and present evidence that shows that these situations also exist at the implementation level. The signature extension approach is introduced to CORE allowing interfaces to encompass diverse implementation variants and to be evolved at a fine level of granularity across groups of features. We re-design two reusable concerns to show that the approach addresses the four difficult situations.

    !!! cite hidden

        ```bibtex
        @PhdThesis{PhDThesis_Schoettle2019,
        author = {Sch\"{o}ttle, Matthias},
        title = {{Model-Based Reuse of Framework APIs: Bridging the Gap Between Models and Code}},
        school = {School of Computer Science, McGill University},
        year = {2019},
        abstract = {Reuse is considered key to software engineering and is very common at the implementation level. Many reusable libraries and frameworks exist and are widely reused. However, in the context of Model-Driven Engineering (MDE) reuse is not very common. Most modelling approaches do not support reuse, requiring a user to start their modelling activity either from scratch or copy and paste pieces from other models.
        This thesis provides a bridge for reusable units between implementation and modelling. We apply the principles of Concern-Oriented Reuse (CORE), a next-generation reuse technology, to lift existing frameworks up from the programming level to the modelling level. The level of abstraction of the API of existing frameworks is raised to the modelling level to facilitate their reuse within design models that are integrated within an MDE process. In addition, the benefits of the higher level of abstraction are exploited to formalize otherwise informally provided information, such as which features the framework provides, the impact of each feature on high-level goals and non-functional qualities, how to adapt the framework to the reuse context, and how the API of each feature is to be used. This thesis defines an automated algorithm that analyses the code of a framework and example code that uses the framework to produce an interface that 1) lists the user-perceivable features of the framework organized in a feature model, and 2) modularizes the API of the framework API according to each feature. The algorithm is implemented and validated on two small frameworks and the Android Notifications API along with an empirical user study.
        To smoothen the transition from a high-level abstraction to a low level of abstraction, i.e., from models to code, this thesis addresses the difficulty caused by the finality of signatures. We identify and discuss four difficult situations for defining high-level interfaces at the modelling level, and present evidence that shows that these situations also exist at the implementation level. The signature extension approach is introduced to CORE allowing interfaces to encompass diverse implementation variants and to be evolved at a fine level of granularity across groups of features. We re-design two reusable concerns to show that the approach addresses the four difficult situations.}
        }
        ```

### 2018

- Benoit Combemale, Jörg Kienzle, Gunter Mussbacher, Olivier Barais, Erwan Bousse, Walter Cazzola, Philippe Collet, Thomas Degueule, Robert Heinrich, Jean-Marc Jézéquel, Manuel Leduc, Tanja Mayerhofer, Sébastien Mosser, **Matthias Schöttle**, Misha Strittmatter, and Andreas Wortmann. [Concern-Oriented Language Development (COLD): Fostering Reuse in Language Engineering](../assets/papers/comlan-combemale2018.pdf). _Computer Languages, Systems & Structures_, 2018.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1016/j.cl.2018.05.004 "View document on publisher site")
    { #paper-18 }

    !!! abstract hidden

        Domain-Specific Languages (DSLs) bridge the gap between the problem space, in which stakeholders work, and the solution space, i.e., the concrete artifacts defining the target system. They are usually small and intuitive languages whose concepts and expressiveness fit a particular domain. DSLs recently found their application in an increasingly broad range of domains, e.g., cyber-physical systems, computational sciences and high-performance computing. Despite recent advances, the development of DSLs is error-prone and requires substantial engineering efforts. Techniques to reuse from one DSL to another and to support customization to meet new requirements are thus particularly welcomed. Over the last decade, the Software Language Engineering (SLE) community has proposed various reuse techniques. However, all these techniques remain disparate and complicate the development of real-world DSLs involving different reuse scenarios. In this paper, we introduce the Concern-Oriented Language Development (COLD) approach, a new language development model that promotes modularity and reusability of language concerns. A language concern is a reusable piece of language that consists of usual language artifacts (e.g., abstract syntax, concrete syntax, semantics) and exhibits three specific interfaces that support (1) variability management, (2) customization to a specific context, and (3) proper usage of the reused artifact. The approach is supported by a conceptual model which introduces the required concepts to implement COLD. We also present concrete examples of some language concerns and the current state of their realization with metamodel-based and grammar-based language workbenches. We expect this work to provide insights into how to foster reuse in language specification and implementation, and how to support it in language workbenches.

    !!! cite hidden

        ```bibtex
        @Article{COMLAN/Combemale2018,
        author = {Benoit Combemale and Jörg Kienzle and Gunter Mussbacher and Olivier Barais and Erwan Bousse and Walter Cazzola and Philippe Collet and Thomas Degueule and Robert Heinrich and Jean-Marc Jézéquel and Manuel Leduc and Tanja Mayerhofer and Sébastien Mosser and Matthias Schöttle and Misha Strittmatter and Andreas Wortmann},
        title = {{Concern-Oriented Language Development (COLD): Fostering Reuse in Language Engineering}},
        journal = {{Computer Languages, Systems \& Structures}},
        year = {2018},
        abstract = {Domain-Specific Languages (DSLs) bridge the gap between the problem space, in which stakeholders work, and the solution space, i.e., the concrete artifacts defining the target system. They are usually small and intuitive languages whose concepts and expressiveness fit a particular domain. DSLs recently found their application in an increasingly broad range of domains, e.g., cyber-physical systems, computational sciences and high-performance computing. Despite recent advances, the development of DSLs is error-prone and requires substantial engineering efforts. Techniques to reuse from one DSL to another and to support customization to meet new requirements are thus particularly welcomed. Over the last decade, the Software Language Engineering (SLE) community has proposed various reuse techniques.
        However, all these techniques remain disparate and complicate the development of real-world DSLs involving different reuse scenarios.
        In this paper, we introduce the Concern-Oriented Language Development (COLD) approach, a new language development model that promotes modularity and reusability of language concerns. A language concern is a reusable piece of language that consists of usual language artifacts (e.g., abstract syntax, concrete syntax, semantics) and exhibits three specific interfaces that support (1) variability management, (2) customization to a specific context, and (3) proper usage of the reused artifact. The approach is supported by a conceptual model which introduces the required concepts to implement COLD. We also present concrete examples of some language concerns and the current state of their realization with metamodel-based and grammar-based language workbenches. We expect this work to provide insights into how to foster reuse in language specification and implementation, and how to support it in language workbenches.},
        doi = {10.1016/j.cl.2018.05.004},
        issn = {1477-8424},
        keywords = {domain-specific languages},
        url = {https://www.sciencedirect.com/science/article/pii/S1477842418300496}
        }
        ```

### 2016

- Céline Bensoussan, **Matthias Schöttle**, and Jörg Kienzle. [Associations in MDE: A Concern-Oriented, Reusable Solution](../assets/papers/ecmfa-bensoussan2016.pdf). In _Modelling Foundations and Applications – 12th European Conference, ECMFA 2016, Held as Part of STAF 2016, Vienna, Austria, July 6-7, 2016, Proceedings_, page 121–137. Springer International Publishing, 2016.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1007/978-3-319-42061-5_8 "View document on publisher site")
    { #paper-17 }

    !!! abstract hidden

        Associations play an important role in model-driven software development. This paper describes a framework that uses Concern-Oriented Reuse (CORE) to capture many different kinds of associations, their properties, behaviour, and various implementation solutions within a reusable artifact: the Association concern. The concern exploits aspect-oriented modelling techniques to modularize the structure and behaviour required for enforcing uniqueness, multiplicity constraints and referential integrity for bidirectional associations. Furthermore, it packages different collection implementation classes that can be used to realize associations. For each implementation class, the impact of its use on non-functional qualities, e.g., memory consumption and performance, has been determined experimentally and formalized. We show how the class diagram notation, i.e., its metamodel and visual representation, can be extended to support reusing the Association concern, and present enhancements to automate feature selection and customization mappings to maximally streamline the reuse process in modelling tools.

    !!! cite hidden

        ```bibtex
        @InProceedings{ECMFA/Bensoussan2016,
        author = {C{\'{e}}line Bensoussan and Matthias Sch{\"{o}}ttle and J{\"{o}}rg Kienzle},
        title = {{Associations in MDE: A Concern-Oriented, Reusable Solution}},
        booktitle = {Modelling Foundations and Applications - 12th European Conference, {ECMFA} 2016, Held as Part of {STAF} 2016, Vienna, Austria, July 6-7, 2016, Proceedings},
        year = {2016},
        pages = {121--137},
        publisher = {Springer International Publishing},
        abstract = {Associations play an important role in model-driven software development. This paper describes a framework that uses Concern-Oriented Reuse (CORE) to capture many different kinds of associations, their properties, behaviour, and various implementation solutions within a reusable artifact: the Association concern. The concern exploits aspect-oriented modelling techniques to modularize the structure and behaviour required for enforcing uniqueness, multiplicity constraints and referential integrity for bidirectional associations. Furthermore, it packages different collection implementation classes that can be used to realize associations. For each implementation class, the impact of its use on non-functional qualities, e.g., memory consumption and performance, has been determined experimentally and formalized. We show how the class diagram notation, i.e., its metamodel and visual representation, can be extended to support reusing the Association concern, and present enhancements to automate feature selection and customization mappings to maximally streamline the reuse process in modelling tools.},
        doi = {10.1007/978-3-319-42061-5_8}
        }
        ```

- Jörg Kienzle, Gunter Mussbacher, Omar Alam, **Matthias Schöttle**, Nicolas Belloir, Philippe Collet, Benoît Combemale, Julien DeAntoni, Jacques Klein, and Bernhard Rumpe. VCU: The Three Dimensions of Reuse. In _Software Reuse: Bridging with Social-Awareness – 15th International Conference, ICSR 2016, Limassol, Cyprus, June 5-7, 2016, Proceedings_, page 122–137. Springer International Publishing, 2016.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1007/978-3-319-35122-3_9 "View document on publisher site")
    { #paper-16 }

    !!! abstract hidden

        Reuse, enabled by modularity and interfaces, is one of the most important concepts in software engineering. This is evidenced by an increasingly large number of reusable artifacts, ranging from small units such as classes to larger, more sophisticated units such as components, services, frameworks, software product lines, and concerns. This paper presents evidence that a canonical set of reuse interfaces has emerged over time: the variation, customization, and usage interfaces (VCU). A reusable artifact that provides all three interfaces reaches the highest potential of reuse, as it explicitly exposes how the artifact can be manipulated during the reuse process along these three dimensions. We demonstrate the wide applicability of the VCU interfaces along two axes: across abstraction layers of a system specification and across existing reuse techniques. The former is shown with the help of a comprehensive case study including reusable requirements, software, and hardware models for the authorization domain. The latter is shown with a discussion on how the VCU interfaces relate to existing reuse techniques.

    !!! cite hidden

        ```bibtex
        @InProceedings{ICSR/Kienzle2016,
        author = {J{\"{o}}rg Kienzle and Gunter Mussbacher and Omar Alam and Matthias Sch{\"{o}}ttle and Nicolas Belloir and Philippe Collet and Beno{\^{\i}}t Combemale and Julien DeAntoni and Jacques Klein and Bernhard Rumpe},
        title = {{VCU: The Three Dimensions of Reuse}},
        booktitle = {{Software Reuse: Bridging with Social-Awareness - 15th International Conference, {ICSR} 2016, Limassol, Cyprus, June 5-7, 2016, Proceedings}},
        year = {2016},
        pages = {122--137},
        publisher = {Springer International Publishing},
        abstract = {Reuse, enabled by modularity and interfaces, is one of the most important concepts in software engineering. This is evidenced by an increasingly large number of reusable artifacts, ranging from small units such as classes to larger, more sophisticated units such as components, services, frameworks, software product lines, and concerns. This paper presents evidence that a canonical set of reuse interfaces has emerged over time: the variation, customization, and usage interfaces (VCU). A reusable artifact that provides all three interfaces reaches the highest potential of reuse, as it explicitly exposes how the artifact can be manipulated during the reuse process along these three dimensions. We demonstrate the wide applicability of the VCU interfaces along two axes: across abstraction layers of a system specification and across existing reuse techniques. The former is shown with the help of a comprehensive case study including reusable requirements, software, and hardware models for the authorization domain. The latter is shown with a discussion on how the VCU interfaces relate to existing reuse techniques.},
        doi = {10.1007/978-3-319-35122-3_9}
        }
        ```

- **Matthias Schöttle**, Omar Alam, Jörg Kienzle, and Gunter Mussbacher. [On the Modularization Provided by Concern-Oriented Reuse](../assets/papers/momo-schoettle2016.pdf). In _Companion Proceedings of the 15th International Conference on Modularity_, MODULARITY Companion 2016, page 184–189. ACM, 2016.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1145/2892664.2892697 "View document on publisher site")
    { #paper-15 }

    !!! abstract hidden

        Reuse is essential in modern software engineering, and hence also in the context of model-driven engineering (MDE). Concern-Oriented Reuse (CORE) proposes a new way of structuring model-driven software development where models of the system are modularized by domains of abstraction within units of reuse called concerns. Within a concern, models are further decomposed and modularized by views and features. High-level concerns can reuse lower-level concerns, and models within a concern can extend other models belonging to the same concern, resulting in complex inter- and intra-concern dependencies. To clearly specify what dependencies are allowed between models belonging to the same or to different concerns, CORE advocates a three-part interface to describe each concern (variation, customization, and usage interfaces). This paper presents the CORE metamodel that formalizes the CORE concepts and enables the integration of different modelling languages within the CORE framework.

    !!! cite hidden

        ```bibtex
        @InProceedings{MOMO/Schoettle2016,
        author = {Matthias Sch{\"{o}}ttle and Omar Alam and J{\"{o}}rg Kienzle and Gunter Mussbacher},
        title = {{On the Modularization Provided by Concern-Oriented Reuse}},
        booktitle = {{Companion Proceedings of the 15th International Conference on Modularity}},
        year = {2016},
        series = {MODULARITY Companion 2016},
        pages = {184--189},
        publisher = {ACM},
        abstract = {Reuse is essential in modern software engineering, and hence also in the context of model-driven engineering (MDE). Concern-Oriented Reuse (CORE) proposes a new way of structuring model-driven software development where models of the system are modularized by domains of abstraction within units of reuse called concerns. Within a concern, models are further decomposed and modularized by views and features. High-level concerns can reuse lower-level concerns, and models within a concern can extend other models belonging to the same concern, resulting in complex inter- and intra-concern dependencies. To clearly specify what dependencies are allowed between models belonging to the same or to different concerns, CORE advocates a three-part interface to describe each concern (variation, customization, and usage interfaces). This paper presents the CORE metamodel that formalizes the CORE concepts and enables the integration of different modelling languages within the CORE framework.},
        doi = {10.1145/2892664.2892697},
        location = {M{\'{a}}laga, Spain}
        }
        ```

### 2015

- Wisam Al Abed, **Matthias Schöttle**, Abir Ayed, and Jörg Kienzle. _Behavior Modeling – Foundations and Applications: International Workshops, BM-FA 2009-2014, Revised Selected Papers_, chapter [Concern-Oriented Behaviour Modelling with Sequence Diagrams and Protocol Models](../assets/papers/bmfa-alabed2015.pdf), page 250–278. Springer International Publishing, Cham, 2015.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1007/978-3-319-21912-7_10 "View document on publisher site")
    { #paper-14 }

    !!! abstract hidden

        Concern-Oriented REuse (CORE) is a multi-view modelling approach that builds on the disciplines of model-driven engineering, software product lines and aspect-orientation to define broad units of reuse, so called concerns. Concerns specify the essence of a design solution and its different variations, if any, using multiple structural and behavioural views, and expose the encapsulated functionality through a three-part interface: a variation, a customization and a usage interface. Concerns can reuse other concerns, and model composition techniques are used to create complex models in which these concerns are intertwined. In such a context, specifying the composition of the models is a non-trivial task, in particular when it comes to specifying the composition of behavioural models. This is the case for CORE message views, which define behaviour using sequence diagrams. In this paper we describe how we added an additional behavioural view to CORE – the state view – that specifies the allowed invocation protocol of class instances. We discuss why Protocol Modelling, a compositional modelling approach based on state diagrams, is an appropriate notation to specify such a state view, and show how we added support for protocol modelling to the CORE metamodel. Finally, we demonstrate how to model using the new state views by means of an example, and explain how state views can be exploited to model-check the correctness of behavioural compositions.

    !!! abstract hidden

        ```bibtex
        @InBook{BMFA/AlAbed2015,
        chapter = {Concern-Oriented Behaviour Modelling with Sequence Diagrams and Protocol Models},
        pages = {250--278},
        title = {{Behavior Modeling -- Foundations and Applications: International Workshops, BM-FA 2009-2014, Revised Selected Papers}},
        publisher = {Springer International Publishing},
        year = {2015},
        author = {Al Abed, Wisam and Sch{\"o}ttle, Matthias and Ayed, Abir and Kienzle, J{\"o}rg},
        editor = {Roubtsova, Ella and McNeile, Ashley and Kindler, Ekkart and Gerth, Christian},
        address = {Cham},
        abstract = {Concern-Oriented REuse (CORE) is a multi-view modelling approach that builds on the disciplines of model-driven engineering, software product lines and aspect-orientation to define broad units of reuse, so called concerns. Concerns specify the essence of a design solution and its different variations, if any, using multiple structural and behavioural views, and expose the encapsulated functionality through a three-part interface: a variation, a customization and a usage interface. Concerns can reuse other concerns, and model composition techniques are used to create complex models in which these concerns are intertwined. In such a context, specifying the composition of the models is a non-trivial task, in particular when it comes to specifying the composition of behavioural models. This is the case for CORE message views, which define behaviour using sequence diagrams. In this paper we describe how we added an additional behavioural view to CORE – the state view – that specifies the allowed invocation protocol of class instances. We discuss why Protocol Modelling, a compositional modelling approach based on state diagrams, is an appropriate notation to specify such a state view, and show how we added support for protocol modelling to the CORE metamodel. Finally, we demonstrate how to model using the new state views by means of an example, and explain how state views can be exploited to model-check the correctness of behavioural compositions.},
        doi = {10.1007/978-3-319-21912-7_10},
        isbn = {978-3-319-21912-7},
        url = {http://dx.doi.org/10.1007/978-3-319-21912-7_10}
        }
        ```

- Romain Alexandre, Cécile Camillieri, Mustafa Berk Duran, Aldo Navea Pina, **Matthias Schöttle**, Jörg Kienzle, and Gunter Mussbacher. [Support for Evaluation of Impact Models in Reuse Hierarchies with jUCMNav and TouchCORE](../assets/papers/models-demos-alexandre2015.pdf). In _Proceedings of the MoDELS 2015 Demo and Poster Session co-located with ACM/IEEE 18th International Conference on Model Driven Engineering Languages and Systems (MoDELS 2015), Ottawa, Canada, September 30th – October 2nd_. CEUR-WS.org, 2015.
    [\[Abstract\]](#) [\[BibTeX\]](#)
    { #paper-13 }

    !!! abstract hidden

        In Concern-Orientation, software systems are built with the help of reusable artifacts called concerns, leading to reuse hierarchies, because higher-level concerns may reuse lower-level concerns. At each level in the reuse hierarchy, a concern uses goal modelling techniques to describe the impact of selected variations from the concern on system qualities such as performance, cost, and user convenience. To reason about trade-offs among system qualities in the whole system, the individual goal models from all levels in the reuse hierarchy have to be considered together. This requires the ability to select variations from different levels in the reuse hierarchy, to connect impacts from lower levels to those at higher levels, and eventually to propagate the evaluation of lower-level goal models to higher-level goal models based on the selection of variations. This tool demonstration reports on such an evaluation mechanism for two tools that provide integrated support for Concern-Orientation: the requirements engineering tool jUCMNav and the software design tool TouchCORE.

    !!! cite hidden

        ```bibtext
        @InProceedings{MODELS/Demos/Alexandre2015,
        author = {Romain Alexandre and C{\'{e}}cile Camillieri and Mustafa Berk Duran and Aldo Navea Pina and Matthias Sch{\"{o}}ttle and J{\"{o}}rg Kienzle and Gunter Mussbacher},
        title = {{Support for Evaluation of Impact Models in Reuse Hierarchies with jUCMNav and TouchCORE}},
        booktitle = {Proceedings of the MoDELS 2015 Demo and Poster Session co-located with ACM/IEEE 18th International Conference on Model Driven Engineering Languages and Systems (MoDELS 2015), Ottawa, Canada, September 30th - October 2nd},
        year = {2015},
        publisher = {CEUR-WS.org},
        abstract = {In Concern-Orientation, software systems are built with the help of reusable artifacts called concerns, leading to reuse hierarchies, because higher-level concerns may reuse lower-level concerns. At each level in the reuse hierarchy, a concern uses goal modelling techniques to describe the impact of selected variations from the concern on system qualities such as performance, cost, and user convenience. To reason about trade-offs among system qualities in the whole system, the individual goal models from all levels in the reuse hierarchy have to be considered together. This requires the ability to select variations from different levels in the reuse hierarchy, to connect impacts from lower levels to those at higher levels, and eventually to propagate the evaluation of lower-level goal models to higher-level goal models based on the selection of variations. This tool demonstration reports on such an evaluation mechanism for two tools that provide integrated support for Concern-Orientation: the requirements engineering tool jUCMNav and the software design tool TouchCORE.},
        url = {http://ceur-ws.org/Vol-1554/PD_MoDELS_2015_paper_10.pdf}
        }
        ```

- **Matthias Schöttle** and Jörg Kienzle. [Concern-Oriented Interfaces for Model-Based Reuse of APIs](../assets/papers/models-schoettle2015.pdf). In _18th ACM/IEEE International Conference on Model Driven Engineering Languages and Systems, MoDELS 2015, Ottawa, ON, Canada, September 30 – October 2, 2015_, page 286–291. IEEE, 2015. (Acceptance rate: 26%)
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1109/MODELS.2015.7338259 "View document on publisher site") [\[View Slides\]](../assets/papers/models-schoettle2015_slides.pdf "View Slides of presentation")
    { #paper-12 }

    !!! abstract hidden

        Reuse is essential in modern software engineering, but limited in the context of MDE by the poor availability of reusable models. On the other hand, reusable code artifacts such as frameworks and libraries are abundant. This paper presents an approach to raise reusable code artifacts to the modelling level by modelling their API using concern-oriented techniques, thus enabling their use in the context of MDE. Our API interface models contain additional information, such as the encapsulated features and their impacts, to assist the developer in the reuse process. Once he has specified his needs, the model interface exposes only the API elements relevant for this specific reuse at the model level, together with the required usage protocol. We show how this approach is applied by hand to model the interface of a small GUI framework and outline how we envision this process to be performed semi-automatically.

    !!! cite hidden

        ```bibtex
        @InProceedings{MODELS/Schoettle2015,
        author = {Matthias Sch{\"{o}}ttle and J{\"{o}}rg Kienzle},
        title = {{Concern-Oriented Interfaces for Model-Based Reuse of APIs}},
        booktitle = {18th {ACM/IEEE} International Conference on Model Driven Engineering Languages and Systems, MoDELS 2015, Ottawa, ON, Canada, September 30 - October 2, 2015},
        year = {2015},
        pages = {286--291},
        publisher = {IEEE},
        note = {(Acceptance rate: 26%)},
        abstract = {Reuse is essential in modern software engineering, but limited in the context of MDE by the poor availability of reusable models. On the other hand, reusable code artifacts such as frameworks and libraries are abundant. This paper presents an approach to raise reusable code artifacts to the modelling level by modelling their API using concern-oriented techniques, thus enabling their use in the context of MDE. Our API interface models contain additional information, such as the encapsulated features and their impacts, to assist the developer in the reuse process. Once he has specified his needs, the model interface exposes only the API elements relevant for this specific reuse at the model level, together with the required usage protocol. We show how this approach is applied by hand to model the interface of a small GUI framework and outline how we envision this process to be performed semi-automatically.},
        doi = {10.1109/MODELS.2015.7338259},
        url = {http://dx.doi.org/10.1109/MODELS.2015.7338259}
        }
        ```

- **Matthias Schöttle**. [Model-Based Reuse of APIs using Concern-Orientation](../assets/papers/models-src-schoettle2015.pdf). In _Proceedings of the ACM Student Research Competition at MODELS 2015 co-located with the ACM/IEEE 18th International Conference MODELS 2015, Ottawa, Canada, September 29, 2015_, page 41–45. CEUR-WS.org, 2015.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[View Poster\]](../assets/papers/models-src-schoettle2015_poster.pdf "View Poster")
    { #paper-11 }

    !!! abstract hidden

        Despite the promises of Model-Driven Engineering (MDE) to address complexity and improve productivity, no widespread adoption has been observed in industry. One reason this paper focuses on is reuse, which is essential in modern software engineering. In the context of MDE, poor availability of reusable models forces modellers to create models from scratch. At the same time, reusable code artifacts, such as frameworks/APIs are widespread. They are an essential part when creating software. This paper presents model-based reuse of APIs, which makes use of concern-driven development (CDD) to raise the level of abstraction of APIs to the modelling level. The interface (API) of a framework is modelled using a feature model and design models for each feature enabling their reuse in MDE. Additional information is embedded, such as impacts and protocols, to assist the developer in the reuse process. We discuss how this enables reuse at the modelling level, the required tool support and future work.

    !!! cite hidden

        ```bibtex
        @InProceedings{MODELS/SRC/Schoettle2015,
        author = {Matthias Sch{\"{o}}ttle},
        title = {{Model-Based Reuse of APIs using Concern-Orientation}},
        booktitle = {Proceedings of the {ACM} Student Research Competition at {MODELS} 2015 co-located with the {ACM/IEEE} 18th International Conference {MODELS} 2015, Ottawa, Canada, September 29, 2015},
        year = {2015},
        pages = {41--45},
        publisher = {CEUR-WS.org},
        abstract = {Despite the promises of Model-Driven Engineering (MDE) to address complexity and improve productivity, no widespread adoption has been observed in industry. One reason this paper focuses on is reuse, which is essential in modern software engineering. In the context of MDE, poor availability of reusable models forces modellers to create models from scratch. At the same time, reusable code artifacts, such as frameworks/APIs are widespread. They are an essential part when creating software. This paper presents model-based reuse of APIs, which makes use of concern-driven development (CDD) to raise the level of abstraction of APIs to the modelling level. The interface (API) of a framework is modelled using a feature model and design models for each feature enabling their reuse in MDE. Additional information is embedded, such as impacts and protocols, to assist the developer in the reuse process. We discuss how this enables reuse at the modelling level, the required tool support and future work.},
        url = {http://ceur-ws.org/Vol-1503/08_pap_schoettle.pdf}
        }
        ```

- **Matthias Schöttle**, Nishanth Thimmegowda, Omar Alam, Jörg Kienzle, and Gunter Mussbacher. [Feature Modelling and Traceability for Concern-driven Software Development with TouchCORE](../assets/papers/modularity-demos-schoettle2015.pdf). In _Companion Proceedings of the 14th International Conference on Modularity_, MODULARITY Companion 2015, page 11–14. ACM, 2015.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1145/2735386.2735922 "View document on publisher site")
    { #paper-10 }

    !!! abstract hidden

        This demonstration paper presents TouchCORE, a multi-touch enabled software design modelling tool aimed at developing scalable and reusable software design models following the concerndriven software development paradigm. After a quick review of concern-orientation, this paper primarily focusses on the new features that were added to TouchCORE since the last demonstration at Modularity 2014 (were the tool was still called TouchRAM). TouchCORE now provides full support for concern-orientation. This includes support for feature model editing and different modes for feature model and impact model visualization and assessment to best assist the concern designers as well as the concern users. To help the modeller understand the interactions between concerns, TouchCORE now also collects tracing information when concerns are reused and stores that information with the woven models. This makes it possible to visualize from which concern(s) a model element in the woven model has originated.

    !!! cite hidden

        ```bibtex
        @InProceedings{Modularity/Demos/Schoettle2015,
        author = {Sch\"{o}ttle, Matthias and Thimmegowda, Nishanth and Alam, Omar and Kienzle, J\"{o}rg and Mussbacher, Gunter},
        title = {{Feature Modelling and Traceability for Concern-driven Software Development with TouchCORE}},
        booktitle = {Companion Proceedings of the 14th International Conference on Modularity},
        year = {2015},
        series = {MODULARITY Companion 2015},
        pages = {11--14},
        publisher = {ACM},
        abstract = {This demonstration paper presents TouchCORE, a multi-touch enabled software design modelling tool aimed at developing scalable and reusable software design models following the concerndriven software development paradigm. After a quick review of concern-orientation, this paper primarily focusses on the new features that were added to TouchCORE since the last demonstration at Modularity 2014 (were the tool was still called TouchRAM). TouchCORE now provides full support for concern-orientation. This includes support for feature model editing and different modes for feature model and impact model visualization and assessment to best assist the concern designers as well as the concern users. To help the modeller understand the interactions between concerns, TouchCORE now also collects tracing information when concerns are reused and stores that information with the woven models. This makes it possible to visualize from which concern(s) a model element in the woven model has originated.},
        acmid = {2735922},
        doi = {10.1145/2735386.2735922},
        isbn = {978-1-4503-3283-5},
        keywords = {concern-driven software development, feature models, impact models, reuse, traceability},
        location = {Fort Collins, CO, USA},
        numpages = {4},
        url = {http://doi.acm.org/10.1145/2735386.2735922}
        }
        ```

### 2014

- **Matthias Schöttle**, Omar Alam, Gunter Mussbacher, and Jörg Kienzle. [Specification of Domain-specific Languages Based on Concern Interfaces](../assets/papers/foal-schoettle2014.pdf). In _Proceedings of the 13th Workshop on Foundations of Aspect-Oriented Languages_, FOAL ’14, page 23–28. ACM, 2014.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1145/2588548.2588551 "View document on publisher site")
    { #paper-9 }

    !!! abstract hidden

        Concern-Driven Development (CDD) is a set of software engineering approaches that focus on reusing existing software models. In CDD, a concern encapsulates related software models and provides three interfaces to facilitate reuse. These interfaces allow to select, customize, and use elements of the concern when an application reuses the concern. Domain-Specific Languages (DSLs) emerged to make modeling accessible to users and domain experts who are not familiar with software engineering techniques. In this paper, we argue that it is possible to create a DSL by using only the three-part interface of the concern modeling the domain in question and that the three-part interface is essential for an appropriate DSL. The DSL enables the composition of the concern with the application under development. We explain this by specifying DSLs based on the interfaces of the Association and the Observer concerns.

    !!! cite hidden

        ```bibtex
        @InProceedings{FOAL/Schoettle2014,
        author = {Sch\"{o}ttle, Matthias and Alam, Omar and Mussbacher, Gunter and Kienzle, J\"{o}rg},
        title = {{Specification of Domain-specific Languages Based on Concern Interfaces}},
        booktitle = {Proceedings of the 13th Workshop on Foundations of Aspect-Oriented Languages},
        year = {2014},
        series = {FOAL '14},
        pages = {23--28},
        publisher = {ACM},
        abstract = {Concern-Driven Development (CDD) is a set of software engineering approaches that focus on reusing existing software models. In CDD, a concern encapsulates related software models and provides three interfaces to facilitate reuse. These interfaces allow to select, customize, and use elements of the concern when an application reuses the concern. Domain-Specific Languages (DSLs) emerged to make modeling accessible to users and domain experts who are not familiar with software engineering techniques. In this paper, we argue that it is possible to create a DSL by using only the three-part interface of the concern modeling the domain in question and that the three-part interface is essential for an appropriate DSL. The DSL enables the composition of the concern with the application under development. We explain this by specifying DSLs based on the interfaces of the Association and the Observer concerns.},
        acmid = {2588551},
        doi = {10.1145/2588548.2588551},
        isbn = {978-1-4503-2798-5},
        keywords = {cdd, concern-driven development, domain-specific languages, dsl, ram, reusable aspect models, reuse},
        location = {Lugano, Switzerland},
        numpages = {6},
        url = {http://doi.acm.org/10.1145/2588548.2588551}
        }
        ```

- Nishanth Thimmegowda, Omar Alam, **Matthias Schöttle**, Wisam Al Abed, Thomas Di’Meco, Laura Martellotto, Gunter Mussbacher, and Jörg Kienzle. [Concern-Driven Software Development with jUCMNav and TouchRAM](../assets/papers/models-demos-thimmegowda2014.pdf). In _Proceedings of the Demonstrations Track of the ACM/IEEE 17th International Conference on Model Driven Engineering Languages and Systems (MoDELS 2014), Valencia, Spain, October 1st and 2nd, 2014_. CEUR-WS.org, 2014.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[View Slides\]](../assets/papers/models-demos-thimmegowda2014_slides.pdf "View Slides of presentation") [\[Watch Demo Teaser\]](https://www.youtube.com/watch?v=Am9jp2y2Uds)
    { #paper-8 }

    !!! abstract hidden

        A concern is a unit of reuse that groups together software artifacts describing properties and behaviour related to any domain of interest to a software engineer at different levels of abstraction. This demonstration illustrates how to specify, design, and reuse concerns with two integrated tools: jUCMNav for feature modelling, goal modelling, and scenario modelling, and TouchRAM for design modelling with class, sequence, and state diagrams, and for code generation. For a demo video see: http://www.youtube.com/watch?v=KWZ7wLsRFFA.

    !!! cite hidden

        ```bibtex
        @InProceedings{MODELS/Demos/Thimmegowda2014,
        author = {Nishanth Thimmegowda and Omar Alam and Matthias Sch{\"{o}}ttle and Wisam Al Abed and Thomas Di'Meco and Laura Martellotto and Gunter Mussbacher and J{\"{o}}rg Kienzle},
        title = {{Concern-Driven Software Development with jUCMNav and TouchRAM}},
        booktitle = {Proceedings of the Demonstrations Track of the {ACM/IEEE} 17th International Conference on Model Driven Engineering Languages and Systems (MoDELS 2014), Valencia, Spain, October 1st and 2nd, 2014},
        year = {2014},
        publisher = {CEUR-WS.org},
        abstract = {A concern is a unit of reuse that groups together software artifacts describing properties and behaviour related to any domain of interest to a software engineer at different levels of abstraction. This demonstration illustrates how to specify, design, and reuse concerns with two integrated tools: jUCMNav for feature modelling, goal modelling, and scenario modelling, and TouchRAM for design modelling with class, sequence, and state diagrams, and for code generation. For a demo video see: http://www.youtube.com/watch?v=KWZ7wLsRFFA.},
        url = {http://ceur-ws.org/Vol-1255/paper9.pdf}
        }
        ```

- Gunter Mussbacher, Daniel Amyot, Ruth Breu, Jean-Michel Bruel, Betty H. C. Cheng, Philippe Collet, Benoit Combemale, Robert B. France, Rogardt Heldal, James Hill, Jörg Kienzle, **Matthias Schöttle**, Friedrich Steimann, Dave Stikkolorum, and Jon Whittle. [The Relevance of Model-Driven Engineering Thirty Years from Now](../assets/papers/models-mussbacher2014.pdf). In Juergen Dingel, Wolfram Schulte, Isidro Ramos, Silvia Abrahão, and Emilio Insfran, editors, _Model-Driven Engineering Languages and Systems: 17th International Conference, MODELS 2014, Valencia, Spain, September 28 – October 3, 2014. Proceedings_, page 183–200. Springer International Publishing, 2014. (Acceptance rate: 24%)
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1007/978-3-319-11653-2_12 "View document on publisher site")
    { #paper-7 }

    !!! abstract hidden

        Although model-driven engineering (MDE) is now an established approach for developing complex software systems, it has not been universally adopted by the software industry. In order to better understand the reasons for this, as well as to identify future opportunities for MDE, we carried out a week-long design thinking experiment with 15 MDE experts. Participants were facilitated to identify the biggest problems with current MDE technologies, to identify grand challenges for society in the near future, and to identify ways that MDE could help to address these challenges. The outcome is a reflection of the current strengths of MDE, an outlook of the most pressing challenges for society at large over the next three decades, and an analysis of key future MDE research opportunities.

    !!! cite hidden

        ```bibtex
        @InProceedings{MODELS/Mussbacher2014,
        author = {Mussbacher, Gunter and Amyot, Daniel and Breu, Ruth and Bruel, Jean-Michel and Cheng, Betty H. C. and Collet, Philippe and Combemale, Benoit and France, Robert B. and Heldal, Rogardt and Hill, James and Kienzle, J{\"o}rg and Sch{\"o}ttle, Matthias and Steimann, Friedrich and Stikkolorum, Dave and Whittle, Jon},
        title = {{The Relevance of Model-Driven Engineering Thirty Years from Now}},
        booktitle = {{Model-Driven Engineering Languages and Systems: 17th International Conference, MODELS 2014, Valencia, Spain, September 28 -- October 3, 2014. Proceedings}},
        year = {2014},
        editor = {Dingel, Juergen and Schulte, Wolfram and Ramos, Isidro and Abrah{\~a}o, Silvia and Insfran, Emilio},
        pages = {183--200},
        publisher = {Springer International Publishing},
        note = {(Acceptance rate: 24%)},
        abstract = {Although model-driven engineering (MDE) is now an established approach for developing complex software systems, it has not been universally adopted by the software industry. In order to better understand the reasons for this, as well as to identify future opportunities for MDE, we carried out a week-long design thinking experiment with 15 MDE experts. Participants were facilitated to identify the biggest problems with current MDE technologies, to identify grand challenges for society in the near future, and to identify ways that MDE could help to address these challenges. The outcome is a reflection of the current strengths of MDE, an outlook of the most pressing challenges for society at large over the next three decades, and an analysis of key future MDE research opportunities.},
        doi = {10.1007/978-3-319-11653-2_12},
        isbn = {978-3-319-11653-2},
        url = {http://dx.doi.org/10.1007/978-3-319-11653-2_12}
        }
        ```

- **Matthias Schöttle**, Omar Alam, Franz-Philippe Garcia, Gunter Mussbacher, and Jörg Kienzle. [TouchRAM: A Multitouch-enabled Software Design Tool Supporting Concern-oriented Reuse](../assets/papers/modularity-demos-schoettle2014.pdf). In _Proceedings of the Companion Publication of the 13th International Conference on Modularity_, MODULARITY ’14, page 25–28. ACM, 2014.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1145/2584469.2584475 "View document on publisher site") [\[View Slides\]](../assets/papers/modularity-demos-schoettle2014_slides.pdf "Vieew Slides of presentation")
    { #paper-6 }

    !!! abstract hidden

        TouchRAM is a multitouch-enabled tool for agile software design modelling aimed at developing scalable and reusable software design models. This paper primarily focusses on the new features that were added to TouchRAM to provide initial support for concern-orientation, and then summarizes the new extensions to behavioural modelling and improved integration with Java. A video that demonstrates the use of TouchRAM can be found here: http://www.youtube.com/watch?v=l8LMqwwRPg4

    !!! cite hidden

        ```bibtex
        @InProceedings{Modularity/Demos/Schoettle2014,
        author = {Sch\"{o}ttle, Matthias and Alam, Omar and Garcia, Franz-Philippe and Mussbacher, Gunter and Kienzle, J\"{o}rg},
        title = {{TouchRAM: A Multitouch-enabled Software Design Tool Supporting Concern-oriented Reuse}},
        booktitle = {Proceedings of the Companion Publication of the 13th International Conference on Modularity},
        year = {2014},
        series = {MODULARITY '14},
        pages = {25--28},
        publisher = {ACM},
        abstract = {TouchRAM is a multitouch-enabled tool for agile software design modelling aimed at developing scalable and reusable software design models. This paper primarily focusses on the new features that were added to TouchRAM to provide initial support for concern-orientation, and then summarizes the new extensions to behavioural modelling and improved integration with Java. A video that demonstrates the use of TouchRAM can be found here: http://www.youtube.com/watch?v=l8LMqwwRPg4},
        acmid = {2584475},
        doi = {10.1145/2584469.2584475},
        isbn = {978-1-4503-2773-2},
        keywords = {class diagrams, concern-oriented software development, model composition, model hierarchies, model interfaces, model reuse, sequence diagrams, state diagrams},
        location = {Lugano, Switzerland},
        numpages = {4},
        url = {http://doi.acm.org/10.1145/2584469.2584475}
        }
        ```

### 2013

- **Matthias Schöttle** and Jörg Kienzle. [On the Challenges of Composing Multi-View Models](../assets/papers/gemoc-schoettle2013.pdf). _In the GEMOC’13 Workshop co-located with the 16th International Conference on Model Driven Engineering Languages and Systems (MODELS 2013)_, October 2013.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[View Slides\]](../assets/papers/gemoc-schoettle2013_slides.pdf "View Slides of presentation")
    { #paper-5 }

    !!! abstract hidden

        The integration of compositional and multi-view modelling techniques is a promising research direction aimed at extending the applicability of model-driven engineering to the development of complex software-intensive systems. This paper outlines a general strategy for extending or integrating existing compositional modelling techniques into a multi-view approach. We demonstrate the practicality of our idea by explaining how we extended the Reusable Aspect Models (RAM) approach, which originally only supported structural modelling using class diagrams, with additional behavioural views based on sequence diagrams. This involved the integration of the metamodels as well as the model weavers.

    !!! cite hidden

        ```bibtex
        @Article{GEMOC/Schoettle2013,
        author = {Sch\"{o}ttle, Matthias and Kienzle, J{\"{o}}rg},
        title = {{On the Challenges of Composing Multi-View Models}},
        journal = {In the GEMOC'13 Workshop co-located with the 16th International Conference on Model Driven Engineering Languages and Systems (MODELS 2013)},
        year = {2013},
        month = {October},
        abstract = {The integration of compositional and multi-view modelling techniques is a promising research direction aimed at extending the applicability of model-driven engineering to the development of complex software-intensive systems. This paper outlines a general strategy for extending or integrating existing compositional modelling techniques into a multi-view approach. We demonstrate the practicality of our idea by explaining how we extended the Reusable Aspect Models (RAM) approach, which originally only supported structural modelling using class diagrams, with additional behavioural views based on sequence diagrams. This involved the integration of the metamodels as well as the model weavers.},
        url = {http://gemoc.org/20130929-GEMOC13/schottle.pdf}
        }
        ```

- Omar Alam, **Matthias Schöttle**, and Jörg Kienzle. [Revising the Comparison Criteria for Composition](../assets/papers/cma-alam2013.pdf). In _Proceedings of the Fourth International Comparing Modeling Approaches Workshop 2013 co-located with the ACM/IEEE 16th International Conference on Model Driven Engineering Languages and Systems (MODELS 2013), Miami, Florida, USA, October 1, 2013._. CEUR-WS.org, 2013.
    [\[Abstract\]](#) [\[BibTeX\]](#)
    { #paper-4 }

    !!! abstract hidden

        The Comparing Modeling Approaches (CMA) workshop proposed in 2011 a set of criteria that allows modellers to understand, analyze, classify and compare various modelling approaches. Based on feedback gained from applying the criteria, the criteria and questionnaire document were revised and extended multiple times. In this paper, we suggest a change to the criteria that is aimed at improving the assessment of model composition. We argue that the definition of composition rule is ambiguous in the current document, and suggest to replace it with an easier and more useful criterion – the input specification. We propose an updated questionnaire and show how to apply it to three modelling approaches: AoURN, RAM, and UML.

    !!! cite hidden

        ```bibtex
        @InProceedings{CMA/Alam2013,
        author = {Omar Alam and Matthias Sch{\"{o}}ttle and J{\"{o}}rg Kienzle},
        title = {{Revising the Comparison Criteria for Composition}},
        booktitle = {Proceedings of the Fourth International Comparing Modeling Approaches Workshop 2013 co-located with the {ACM/IEEE} 16th International Conference on Model Driven Engineering Languages and Systems {(}{MODELS} 2013), Miami, Florida, USA, October 1, 2013.},
        year = {2013},
        publisher = {CEUR-WS.org},
        abstract = {The Comparing Modeling Approaches (CMA) workshop proposed in 2011 a set of criteria that allows modellers to understand, analyze, classify and compare various modelling approaches. Based on feedback gained from applying the criteria, the criteria and questionnaire document were revised and extended multiple times. In this paper, we suggest a change to the criteria that is aimed at improving the assessment of model composition. We argue that the definition of composition rule is ambiguous in the current document, and suggest to replace it with an easier and more useful criterion – the input specification. We propose an updated questionnaire and show how to apply it to three modelling approaches: AoURN, RAM, and UML.},
        url = {http://ceur-ws.org/Vol-1076/paper6.pdf}
        }
        ```

- **Matthias Schöttle**, Omar Alam, Abir Ayed, and Jörg Kienzle. [Concern-Oriented Software Design with TouchRAM](../assets/papers/models-demos-schoettle2013.pdf). In _Joint Proceedings of MODELS’13 Invited Talks, Demonstration Session, Poster Session, and ACM Student Research Competition co-located with the 16th International Conference on Model Driven Engineering Languages and Systems (MODELS 2013), Miami, USA, September 29 – October 4, 2013._, page 51–55. CEUR-WS.org, 2013.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[Watch Demo Teaser\]](https://www.youtube.com/watch?v=Dxc5LvV3Nsw)
    { #paper-3 }

    !!! abstract hidden

        TouchRAM is a multitouch-enabled tool for agile software design modelling aimed at developing scalable and reusable software design models. This paper briefly summarizes the main features of the Reusable Aspect Models modelling approach, highlights the new features of TouchRAM that have been added in the last 6 months, and then describes how the tool is used to incrementally elaborate a software design model. A video that demonstrates the use of TouchRAM can be found here: http://www.youtube.com/watch?v=l8LMqwwRPg4

    !!! cite hidden

        ```bibtex
        @InProceedings{MODELS/Demos/Schoettle2013,
        author = {Matthias Sch{\"{o}}ttle and Omar Alam and Abir Ayed and J{\"{o}}rg Kienzle},
        title = {{Concern-Oriented Software Design with TouchRAM}},
        booktitle = {Joint Proceedings of MODELS'13 Invited Talks, Demonstration Session, Poster Session, and {ACM} Student Research Competition co-located with the 16th International Conference on Model Driven Engineering Languages and Systems {(MODELS} 2013), Miami, USA, September 29 - October 4, 2013.},
        year = {2013},
        pages = {51--55},
        publisher = {CEUR-WS.org},
        abstract = {TouchRAM is a multitouch-enabled tool for agile software design modelling aimed at developing scalable and reusable software design models. This paper briefly summarizes the main features of the Reusable Aspect Models modelling approach, highlights the new features of TouchRAM that have been added in the last 6 months, and then describes how the tool is used to incrementally elaborate a software design model. A video that demonstrates the use of TouchRAM can be found here: http://www.youtube.com/watch?v=l8LMqwwRPg4},
        url = {http://ceur-ws.org/Vol-1115/demo10.pdf}
        }
        ```

### 2012

- Wisam Al Abed, Valentin Bonnet, **Matthias Schöttle**, Engin Yildirim, Omar Alam, and Jörg Kienzle. [TouchRAM: A Multitouch-Enabled Tool for Aspect-Oriented Software Design](../assets/papers/sle-alabed2012.pdf). In Krzysztof Czarnecki and Görel Hedin, editors, _Software Language Engineering: 5th International Conference, SLE 2012, Dresden, Germany, September 26-28, 2012, Revised Selected Papers_, page 275–285. Springer Berlin Heidelberg, 2012.
    [\[Abstract\]](#) [\[BibTeX\]](#) [\[DOI\]](http://dx.doi.org/10.1007/978-3-642-36089-3_16 "View document on publisher site")
    { #paper-2 }

    !!! abstract hidden

        This paper presents TouchRAM, a multitouch-enabled tool for agile software design modeling aimed at developing scalable and reusable software design models. The tool gives the designer access to a vast library of reusable design models encoding essential recurring design concerns. It exploits model interfaces and aspect-oriented model weaving techniques as defined by the Reusable Aspect Models (RAM) approach to enable the designer to rapidly apply reusable design concerns within the design model of the software under development. The paper highlights the user interface features of the tool specifically designed for ease of use, reuse and agility (multiple ways of input, tool-assisted reuse, multitouch), gives an overview of the library of reusable design models available to the user, and points out how the current state-of-the-art in model weaving had to be extended to support seamless model reuse.

    !!! cite hidden

        ```bibtex
        @InProceedings{SLE/AlAbed2012,
        author = {Al Abed, Wisam and Bonnet, Valentin and Sch{\"o}ttle, Matthias and Yildirim, Engin and Alam, Omar and Kienzle, J{\"o}rg},
        title = {{TouchRAM: A Multitouch-Enabled Tool for Aspect-Oriented Software Design}},
        booktitle = {Software Language Engineering: 5th International Conference, SLE 2012, Dresden, Germany, September 26-28, 2012, Revised Selected Papers},
        year = {2012},
        editor = {Czarnecki, Krzysztof and Hedin, G{\"o}rel},
        pages = {275--285},
        publisher = {Springer Berlin Heidelberg},
        abstract = {This paper presents TouchRAM, a multitouch-enabled tool for agile software design modeling aimed at developing scalable and reusable software design models. The tool gives the designer access to a vast library of reusable design models encoding essential recurring design concerns. It exploits model interfaces and aspect-oriented model weaving techniques as defined by the Reusable Aspect Models (RAM) approach to enable the designer to rapidly apply reusable design concerns within the design model of the software under development. The paper highlights the user interface features of the tool specifically designed for ease of use, reuse and agility (multiple ways of input, tool-assisted reuse, multitouch), gives an overview of the library of reusable design models available to the user, and points out how the current state-of-the-art in model weaving had to be extended to support seamless model reuse.},
        doi = {10.1007/978-3-642-36089-3_16},
        isbn = {978-3-642-36089-3},
        url = {http://dx.doi.org/10.1007/978-3-642-36089-3_16}
        }
        ```

- **Matthias Schöttle**. [Aspect-Oriented Behavior Modeling In Practice](../assets/papers/masterthesis_schoettle2012.pdf). Master’s thesis, Department of Computer Science, Karlsruhe University of Applied Sciences, September 2012. Conducted at the School of Computer Science, McGill University, Montreal, Canada.
    [\[Abstract\]](#) [\[BibTeX\]](#)
    { #paper-1 }

    !!! abstract hidden

        Aspect-Oriented Programming (AOP) addresses the separation of cross-cutting concerns from the business logic on the source code level. Aspect-Oriented Modeling (AOM) allows to do this on a higher level of abstraction where cross-cutting concerns are addressed during earlier phases of the software development process. Reusable Aspect Models (RAM) is an aspect-oriented multi-view modeling approach that allows detailed design of a software system. Notations similar to UML class, sequence and state diagrams are used to describe the structure and behavior of a reusable aspect. Previously a meta-model and a weaver was defined for the structural view (class diagram) to be used in a tool for RAM. The definition of message views (similar to Sequence Diagrams) and weaving of message views has been only done in theory so far. In this thesis we present the transformation of message views defined in theory into practice to be usable in the RAM tool. The message views and their features are evaluated for feasibility and adjustments are made where necessary to obtain a well-defined meta-model at the end. The weaving of message views is formalized and a general weaving process defined that entails all views. The weaver for message views was then implemented. Finally, the multitouch-enabled tool TouchRAM is extended with support for visualization and weaving of message views. Furthermore, ideas are presented on how to offer streamlined editing of message views and how the overall architecture of TouchRAM can be improved to increase the code quality and maintainability.

    !!! cite hidden

        ```bibtex
        @MastersThesis{Masterthesis_Schoettle2012,
        author = {Sch\"{o}ttle, Matthias},
        title = {{Aspect-Oriented Behavior Modeling In Practice}},
        school = {Department of Computer Science, Karlsruhe University of Applied Sciences},
        year = {2012},
        month = {September},
        note = {Conducted at the School of Computer Science, McGill University, Montreal, Canada.},
        abstract = {Aspect-Oriented Programming (AOP) addresses the separation of cross-cutting concerns from the business logic on the source code level. Aspect-Oriented Modeling (AOM) allows to do this on a higher level of abstraction where cross-cutting concerns are addressed during earlier phases of the software development process.
        Reusable Aspect Models (RAM) is an aspect-oriented multi-view modeling approach that allows detailed design of a software system. Notations similar to UML class, sequence and state diagrams are used to describe the structure and behavior of a reusable aspect. Previously a meta-model and a weaver was defined for the structural view (class diagram) to be used in a tool for RAM. The definition of message views (similar to Sequence Diagrams) and weaving of message views has been only done in theory so far.
        In this thesis we present the transformation of message views defined in theory into practice to be usable in the RAM tool. The message views and their features are evaluated for feasibility and adjustments are made where necessary to obtain a well-defined meta-model at the end. The weaving of message views is formalized and a general weaving process defined that entails all views. The weaver for message views was then implemented. Finally, the multitouch-enabled tool TouchRAM is extended with support for visualization and weaving of message views. Furthermore, ideas are presented on how to offer streamlined editing of message views and how the overall architecture of TouchRAM can be improved to increase the code quality and maintainability.},
        pages = {86},
        url = {http://mattsch.com/papers/masterthesis.pdf}
        }
        ```
