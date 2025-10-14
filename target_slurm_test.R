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
      {
        filtered <- raw_data %>% filter(!is.na(Ozone))
        purrr::map(1:50, ~ dplyr::slice_sample(filtered, prop = 0.8))
      },
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid")
      )
    ),
    tar_target(
      ozone_lm,
      command = lm(Ozone ~ Wind + Temp, analysis_data[[1]]),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      ),
      pattern = map(analysis_data)
    ),
    tar_target(
      ozone_preds,
      predict(ozone_lm, newdata = analysis_data[[1]]),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      ),
      pattern = map(ozone_lm, analysis_data)
    ),
    tar_target(
      ozone_rmse,
      sqrt(mean((ozone_preds - analysis_data[[1]]$Ozone)^2)),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      ),
      pattern = map(ozone_preds, analysis_data)
    ),
    tar_target(
      sf_data,
      command = {
        df <- analysis_data[[1]]
        len <- nrow(df)
        df$lon <- -120 + 10 * runif(len)
        df$lat <- 35 + 5 * runif(len)
        st_as_sf(df, coords = c("lon", "lat"), crs = 4326)
      },
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      ),
      pattern = map(analysis_data)
    )
  )
