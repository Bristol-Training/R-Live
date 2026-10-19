# Render all course outputs in one go:
#   - r-course-notes.html           instructor notes (includes "Instructor notes" boxes)
#   - r-course-notes-attendee.html  attendee notes (instructor boxes removed)
#   - r-course-slides.html          revealjs slides
#
# Run from this folder, either by sourcing this file in RStudio or with:
#   Rscript render.R

library(quarto)

# Make sure we are running from the folder this script lives in
if (!file.exists("r-course-notes.qmd")) {
    stop("Please run render.R from the combined-notes folder ",
         "(in RStudio: Session > Set Working Directory > To Source File Location)")
}

cat("Rendering instructor notes...\n")
quarto_render("r-course-notes.qmd",
              output_file = "r-course-notes.html")

cat("Rendering attendee notes...\n")
quarto_render("r-course-notes.qmd",
              output_file = "r-course-notes-attendee.html",
              metadata = list(attendee = TRUE))

cat("Rendering slides...\n")
quarto_render("r-course-slides.qmd",
              output_file = "r-course-slides.html")

# Safety check: the attendee copy must not contain any instructor notes
attendee_html <- readLines("r-course-notes-attendee.html", warn = FALSE)
if (any(grepl("Instructor notes", attendee_html, fixed = TRUE))) {
    stop("r-course-notes-attendee.html still contains instructor notes - ",
         "check that every instructor block is wrapped in ",
         "::: {.content-hidden when-meta=\"attendee\"}")
}

cat("\nDone! Created:\n")
for (f in c("r-course-notes.html", "r-course-notes-attendee.html", "r-course-slides.html")) {
    cat(sprintf("  %-30s %s\n", f, normalizePath(f)))
}
