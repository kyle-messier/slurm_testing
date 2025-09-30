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
      ozone_lm,
      command = lm(Ozone ~ Wind + Temp, analysis_data),
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
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
      sf_data,
      command = {
        df <- analysis_data
        len <- nrow(df)
        df$lon <- -120 + 10 * runif(len)
        df$lat <- 35 + 5 * runif(len)
        st_as_sf(df, coords = c("lon", "lat"), crs = 4326)
      },
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_grid"),
      )
    ),
    tar_target(
      engine_base_mlp,
      command = {
        parsnip::mlp(
          hidden_units = c(parsnip::tune(), 32L),
          dropout = c(parsnip::tune(), 0.3),
          epochs = 1000,
          activation = "leaky_relu",
          learn_rate = parsnip::tune()
        ) %>%
          parsnip::set_engine(
            "brulee",
            device = "cuda",
            early_stopping = TRUE
          ) %>%
          parsnip::set_mode("regression")
      },
      resources = targets::tar_resources(
        crew = targets::tar_resources_crew(controller = "controller_gpu"),
      )
    )
  )
