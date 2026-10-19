# Render all course outputs in one go:
#   resources/   the course pages
#       r-course-notes.html           instructor notes (includes "Instructor notes" boxes)
#       r-course-notes-attendee.html  attendee notes (instructor boxes removed)
#       r-course-slides.html          revealjs slides
#   docs/        the course website for GitHub Pages
#       index.html       attendee notes with the slides embedded at the top
#       slides.html      copy of resources/r-course-slides.html
#       instructor.html  copy of resources/r-course-notes.html
#
# Run from this folder, either by sourcing this file in RStudio or with:
#   Rscript render.R

library(quarto)

# Make sure we are running from the folder this script lives in
if (!file.exists("source/r-course-notes.qmd")) {
    stop("Please run render.R from the top-level course folder ",
         "(in RStudio: Session > Set Working Directory > To Source File Location)")
}

dir.create("resources", showWarnings = FALSE)
dir.create("docs", showWarnings = FALSE)

# Quarto writes each output next to its .qmd (in source/), so render there
# and then move the file to where it belongs
render_to <- function(input, output, metadata = NULL) {
    output_file <- basename(output)
    quarto_render(file.path("source", input),
                  output_file = output_file,
                  metadata = metadata)
    unlink(output)
    if (!file.rename(file.path("source", output_file), output)) {
        stop("Could not move ", output_file, " to ", output)
    }
}

cat("Rendering instructor notes...\n")
render_to("r-course-notes.qmd", "resources/r-course-notes.html")

cat("Rendering attendee notes...\n")
render_to("r-course-notes.qmd", "resources/r-course-notes-attendee.html",
          metadata = list(attendee = TRUE))

cat("Rendering slides...\n")
render_to("r-course-slides.qmd", "resources/r-course-slides.html")

cat("Rendering course website...\n")
render_to("r-course-notes.qmd", "docs/index.html",
          metadata = list(attendee = TRUE, site = TRUE))
file.copy("resources/r-course-slides.html", "docs/slides.html", overwrite = TRUE)
file.copy("resources/r-course-notes.html", "docs/instructor.html", overwrite = TRUE)
file.create("docs/.nojekyll")  # serve the files as they are, no Jekyll processing

# Safety check: the attendee copies must not contain any instructor notes
for (f in c("resources/r-course-notes-attendee.html", "docs/index.html")) {
    if (any(grepl("Instructor notes", readLines(f, warn = FALSE), fixed = TRUE))) {
        stop(f, " still contains instructor notes - ",
             "check that every instructor block is wrapped in ",
             "::: {.content-hidden when-meta=\"attendee\"}")
    }
}

cat("\nDone! Created:\n")
for (f in c("resources/r-course-notes.html", "resources/r-course-notes-attendee.html",
            "resources/r-course-slides.html",
            "docs/index.html", "docs/slides.html", "docs/instructor.html")) {
    cat(sprintf("  %-40s %s\n", f, normalizePath(f)))
}
