# Introduction to R and Data Analysis (combined course)

A single live-coding course combining the JGI's *Intro to R (Part 1)*, *Intro to R (Part 2)* and *Introduction to Data Analysis in R*. All examples use the Palmer penguins data from the [`palmerpenguins`](https://allisonhorst.github.io/palmerpenguins/) package.

This course is written with [Quarto](https://quarto.org).

## What's in this folder

| File | What it is |
|---|---|
| `r-course-notes.qmd` | **Source** for the course notes (one document covering every topic) |
| `r-course-slides.qmd` | **Source** for the revealjs slides that accompany the live-coding session |
| `render.R` | Renders everything in one go (see below) |
| `styles.scss` | Notes styling (same as the existing JGI courses) |
| `slides.scss` | Slide theme (JGI purple) |
| `assets/` | Logo and images |
| `DESCRIPTION` | R packages the course needs |

## Which output goes to whom

| Output | Audience | Contains |
|---|---|---|
| `r-course-notes.html` | **Delivery team** | Full notes **plus** red *Instructor notes* boxes (timings, live-coding cues, common pitfalls) |
| `r-course-slides.html` | **Delivery team** (presented on screen) | Overview slides for each section |
| `r-course-notes-attendee.html` | **Attendees** (send at the end of the session) | Full notes with all instructor notes removed |

All three are single, self-contained HTML files (images and styles are embedded), so they can be emailed or uploaded to a VLE as they are.

## Setup

Install Quarto from <https://quarto.org/docs/get-started/>, then install the R packages:

```r
install.packages(c("tidyverse", "palmerpenguins", "lme4", "rpart",
                   "quarto", "knitr", "rmarkdown"))
```

## Rendering

### Everything at once (recommended)

From this folder, run:

```bash
Rscript render.R
```

or open `render.R` in RStudio, set the working directory to this folder (*Session → Set Working Directory → To Source File Location*) and click **Source**.

This creates all three HTML files, and checks that the attendee version contains no instructor notes.

### One output at a time

From a terminal in this folder:

```bash
# Instructor notes  ->  r-course-notes.html
quarto render r-course-notes.qmd

# Attendee notes    ->  r-course-notes-attendee.html
quarto render r-course-notes.qmd -M attendee:true --output r-course-notes-attendee.html

# Slides            ->  r-course-slides.html
quarto render r-course-slides.qmd
```

### Live preview while editing

```bash
quarto preview r-course-notes.qmd     # instructor view
quarto preview r-course-slides.qmd
```

The preview refreshes in your browser each time you save. (In RStudio you can also use the **Render** button on an open `.qmd` file, which produces the instructor version.)

## Editing the notes

The notes follow the house style of the existing JGI courses:

```markdown
::: {#exerciseN .callout-note icon=false title='Exercise'}
The exercise (one at the end of each section).
:::

::: {#answerN .callout-caution icon=false title='Answer' collapse="true"}
The answer (collapsed by default).
:::

::: {#keypointsN .callout-tip icon=false title='Key points'}
Important concepts.
:::
```

### Adding instructor-only content

Wrap anything that attendees should **not** see in a `content-hidden` block. It shows in the instructor version and is removed from the attendee version:

```markdown
::: {.content-hidden when-meta="attendee"}
::: {.callout-important icon=false title='Instructor notes'}
**Live code:** ...

**Pitfalls:** ...
:::
:::
```

Keep the title `Instructor notes`: `render.R` searches for it to check that nothing has leaked into the attendee copy.

### Deliberate errors

Code chunks that demonstrate an error on purpose are marked `#| purl: false`. This keeps them out of a script extracted with `knitr::purl("r-course-notes.qmd")`, so the extracted script runs from top to bottom. `knitr::purl()` is a handy way to produce a complete "solutions" script.

## Credits

Developed by the [Jean Golding Institute](https://www.bristol.ac.uk/golding/), based on materials originally written by Christopher Woods and Matt Williams.

Jean Golding Institute © CC-BY 4.0
