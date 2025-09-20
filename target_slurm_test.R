target_slurm_test <-
  list(
    tar_target(
      raw_data,
      airquality,
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      analysis_data,
      raw_data %>% filter(!is.na(Ozone)),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      hist,
      create_plot(data),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      ozone_lm,
      command = lm(Ozone ~ Wind + Temp, analysis_data),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_taraget(
      ozone_preds,
      predict(ozone_lm, newdata = analysis_data),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      ozone_rmse,
      sqrt(mean((ozone_preds - analysis_data$Ozone)^2)),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      report,
      {
        rmarkdown::render(
          "report.Rmd",
          output_file = file.path(
            "reports",
            paste0("report-", Sys.Date(), ".html")
          ),
          params = list(rmse = ozone_rmse)
        )
        NULL
      },
      format = "file",
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    )
  )
