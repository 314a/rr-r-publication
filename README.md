![](img/header.png)

# RR Workshop Tutorial: Writing publications with R (Work in progress!)

This tutorial in the context of the **Reproducible Research Workshop** provides you with the first steps on how to write publications in R.

**Objectives of this tutorial:**

* Installation and setup of R, RStudio and Miktex
* Load a template project to RStudio (or Fork it from GitHub, see part 4 of the previous tutorial)
* Generate an example report as an HTML, Word or Latex document
* Generate a sample publication
* Prepare a publication for use in Overleaf

## Motivation

Wouldn't it be great to combine analysis, data, results, plots, bibliography and text all together and generate and later on regenerate a report or publication with the click of one button?

Some reasons to create a reproducible report with R (and Markdown) are:

* It makes changing and updating your publications easier
* You can easily change the output format from PDF (via Latex), Word and HTML
* You can keep all relevant parts of your project together
* **TODO** add more reasons

## Publication generation workflow in R

R with the help of some tools mainly knitr and behind the scenes Pandoc enables you to automatically generate reports in various formats (HTML, PDF and Word) from your analysis.

The key elements in this process are: 

* **[RMarkdown](http://rmarkdown.rstudio.com):** Convenient to produce reproducible documents. It allows to combine your text content and code in one single file. Simply put it's markdown text with distinct are code blocks. Good for version control.
* **[Markdown](https://daringfireball.net/projects/markdown):** Simple markup language, fast to write and easy to read, lacks fancy formating options (but are they really needed?)
* **[knitr](http://yihui.name/knitr):** R package for dynamic report generation in R 
* **[Pandoc](http://johnmacfarlane.net/pandoc):** Universal document converter, pandoc is your swiss army-knife to convert and render documents from one markup language into another. (RStudio comes with the Pandoc binaries included)

In **RMarkdown** the text is written in _markdown_ and the _R code_ is put in distinct _code blocks_ (or code chunks). The text and R chunks together are then rendered with the knitr package to a document.

The workflow to create such a document with R is:

1. Create an .Rmd file (Markdown with R code blocks, called "code chunks")
2. Write your report and include your data, code, analysis and text
3. Use the knitr package to combine text and the R scripts and render a markdown file from the RMarkdown
4. Convert the files with Pandoc to generate html (can be self-contained), doc, Word documents

In RStudio the **knit button** combines steps 3+4 behind the scene to compile the documents from the RMarkdown file.

![RMarkdown workflow](img/processRStudio.png)

## Part 1: Installation & Setup

**1. Installation:** To get started you need the following software installed on your computer: If you are new to R, then you need to install [R](https://www.r-project.org) and [RStudio](https://www.rstudio.com). Furtermore to generate PDF files you'll need a running Latex environment such as [Miktex](http://miktex.org). 

Ideally you also have Git ([Download Git](https://git-scm.com/downloads)) installed and setup. To get an idea on how to use Git follow the tutorial _"How to use Git with R and RStudio"_.

1. **R ([Download R](https://cloud.r-project.org)):** Download and install R (if not already installed).
2. **RStudio ([Download RStudio Desktop](https://www.rstudio.com/products/RStudio/#Desktop)):**  Download and Install RStudio (if not already installed) 
3. **Miktex ([Download Miktex](http://miktex.org/download))**: Download and install Miktex, if you want to generate PDF documents. To generate PDFs Pandoc requires an working Latex environment. 
4. (Git Tutorial) **Git ([Download Git](https://git-scm.com/downloads)):** Download and Install Git. _([Miktex Portable (http://miktex.org/portable))_
   _Optional Git clients: [SourceTree](https://www.sourcetreeapp.com) or [GitHub Desktop](https://desktop.github.com)_.
5. (Git Tutorial) **GitHub account**: On [GitHub](https://github.com/) create yourself a free GitHub account. _If you are new to Git follow the 15 min [TryGit Tutorial](https://try.github.io) to get a quick introduction to Git._ 

**2. Setup up Latex/Miktex in RStudio**:

With Miktex installed the generation of PDF files via Latex should run just fine. RStudio will find the Latex environment through the PATH variable.

**Note:** On windows check the PATH variables in R console with `Sys.getenv("PATH")` (If you want to set a PATH variable for one session only, you can use the following command `Sys.setenv(PATH = paste(Sys.getenv("PATH"), "C:\\YOURPATH\\MikTeX\\miktex\\bin", sep=.Platform$path.sep))`)

**3. Install the knitr package:** To generate knit packages, you need the **knit** package in R. Type the following in the R console `install.packages("knit")` and hit enter to install this package. 

## Part 2: Download the Github repository with the tutorial project

The following Github repository https://github.com/314a/rr-r-publication contains the example files used in this tutorial. You can either download the repository .zip file or clone the project as a new R Project.

a) **Download .zip** file https://github.com/314a/rr-rstudio-git/archive/master.zip. Unzip the file in your R Workspace folder, where you store all your different RProjects. Rename the _master_ folder to _rr-r-publication_. Within this folder open the _rr-r-publication.RProj_ file to open this RStudio project.
b) **Clone the repository**: If you have Git installed, go to _File > New Project..._ and create a new project from _Version Control_ and enter the following repository url: `https://github.com/314a/rr-r-publication.git`. RStudio then clones the repository into R workspace folder you provided.

## Part 3: Generate a simple RMarkdown file

A RMarkown file consists of **Markdown** text, **R Code chunks** and a optional **YAML header**.

* The **YAML header** block on top of the file serves to include some metadata about the RMarkdown document, such as who is the author of the document or should it be rendered into a HTML, PDF or a word document. A YAML block is on the top of the page and delimited with `---`.
* The **R code chunks** are where you can add your R code and start with ` ```{r} ` on a new line and end with ` ``` ` on a new line. 
* The rest of the document is a plain text document with the **Markdown** syntax. In RStudio got to _Help > Markdown Quick Reference_ to open the Markdown syntax reference. 

The following minimal RMarkdown example contains all three RMarkdown parts, a YAML header in the beginning, text with the Markdown syntax and R code chunks.

**RMarkdown minimal example:**

    ---
    title: "RMarkdown Minimal Example"
    author: "John Snow"
    date: "19 August 2016"
    output: html_document
    ---
    
    ## Markdown 
    
    This is a **RMarkdown** document. You can write text in **bold** or _cursive_, include [links](http://geo.uzh.ch) or add inline formulae $y=x+3$
    
    ## Markdown with R code
    
    ```{r}
    d  <- data.frame(participants=1:10,height=rnorm(10,sd=30,mean=170)) 
    summary(d)
    ```
    you can include R elements inline and generate plots:
    
    ```{r chunk_name}
    plot(d)
    ```
    
    There were `r nrow(d)` participants.

**1. Create an new RMarkdown document**: In RStudio go to _File > New File > RMarkdown..._. In the menu keep the default output format as _HTML_ and press OK. RSTudio opens an example RMarkdown document to provide a fast dive into RMarkdown. Copy the content of the **RMarkdown minimal example** and replace the new RMarkdown example with it.

![R Markdown File](img/RMarkdownNewFile.png)

**2. Generate the HTML document**: Rather _knit_ the document. First save the RMarkdown file as _publication_minimal.Rmd_ in your R working directory. On top of the RMarkdown document press the _knit HTML_ button. Depending on the settings in the YAML metadata it should be set to HTML. After some seconds the created html document will open in a separate window in RStudio.

![RSTudio knit menu](img/RStudio-knit.png)

## Part 4: Edit a simple RMarkdown file

**1.  Edit Markdown elements**: Now lets edit the RMarkdown file. Include the following snippet with new Markdown elements -- a list, a table and an image -- below the first paragraph (Line 10) of your document and knit the document again.

    **List:**
    
    1. ordered list element
    2. make it an unordered list 
    3. replace the numbers with `*`  
    
    **Table:**
    
    Name          | Value
    --------------| ------------------
    Reproducible  | is coool
    Research      | and fun!
    
    : This is a table caption
    
    **Image:**
    
    ![Reproducible Research Logo](figures/logo.png)
    
**2. Edit R code chunks:** R chunks are evluated in order as they appear in the document. It is good practice to give each code chunk a name like `chunk_name` in the second r code chunk in our file. Let's rename the first code chunk to `{r simulate_data}` and the second to `{r scatterplot}`. 

R code chunks will print the R code and the output of that code chunk. _Chunk options_ allow to modify the behavior on how the code chunk 'behaves'. If no R code should be printed, then set the `echo = FALSE` option or if the figure size should overwrite the default size set `fig.width=4,fig.height=2`.

    ```{r simulate_data, echo=FALSE}
    d  <- data.frame(participants=1:10,height=rnorm(10,sd=30,mean=170)) 
    summary(d)
    ```
    you can include R elements inline and generate plots:
    
    ```{r scatterplot, echo=FALSE, fig.width=4,fig.height=2}
    plot(d)
    ```
    
**Advanced:** You can set these options also globally with `opts_chunk$set` in the beginning of the RMarkown file. I often use the following code chunk in the beginning of each RMarkdown document (after the header).

    ```{r setup,comment=FALSE, message = FALSE, echo=FALSE,warning=FALSE}
    rm(list=ls())           # Clean the environment
    options(scipen=6)       # display digits proberly!! not the scientific version
    options(digits.secs=6)  # use milliseconds in Date/Time data types
    options(warning=FALSE)  # don't show warnings
    library(knitr)          # set global knitr options of the document
    # Here we set the figure path to be in the figure folder and we also set the R code invisible to not show when the document is rendered
    opts_chunk$set(comment="", message = FALSE, echo=FALSE, error=FALSE, warning=FALSE)
    ```

**3. Edit the YAML header:** Lets edit the header by adding our names and even mix in R code to automatically set the document date to today.

    ---
    title: "RMarkdown Minimal Example"
    author: "your name"
    date: "`r Sys.Date()`"
    output: html_document
    ---
    
- edit yaml 


## Citation and References

https://www.zotero.org/styles

## Create and structure an R project 

* **Folder structure:**: What structure might be useful?
* **Data organisation:**: How do you organise your (raw/derived) data? 
* **Documentation:**: What do you document? Will you be reusing the data? Difficult parts, will you remember how you did it?
* **Scope:**: What's the scope of the project?
* **Report:**: Report structure
* **Reusability:**: Which functionalities will you reuse?
* **Extendable:**: What if the project becomes larger?

**Example folder structure:**   

* **R**: R folder storing all the *.r* code files
* **data**: Data folder with the raw and the derived data (e.g. data.csv, data.RData)
* **figures**: Figure folder (e.g. pictures, logo etc.)
* *myproject.RProj*: RStudio project file
* *ProjectReport.Rmd*: RMarkdown storing the report text and R analysis code
* *ProjectReport.pdf*: Generated report from the RMarkdown file
* *README.md*: Information about the project. *(good practice)*
    

## Practical tips

1. Create an RStudio project for every project in a separate folder 
2. Document everything, your documents should be understandable by someone other than you
3. Plan your project, organise and store your data, code and reports
4. Start small, with a subset of your data
5. Link your workflow (e.g. data files as an input to your analysis files)
6. Structure your project into the following steps: 1. Data collection; 2. Preprocessing; 3. Analysis; 4. Presentation 

## Useful links

- [RMarkdown cheatsheet](http://shiny.rstudio.com/articles/rm-cheatsheet.html) https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf
- [RMarkdown 2 cheatsheet](http://www.utstat.toronto.edu/reid/sta2201s/rmarkdown-reference.pdf)


