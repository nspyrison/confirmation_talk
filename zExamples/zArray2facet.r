library(spinifex)
library(gganimate)
library(ggplot2)

f_dat  <- tourr::rescale(flea[,1:6])
f_cat  <- factor(flea$species)
f_path <- save_history(f_dat, guided_tour(holes()))
f_bas  <- matrix(f_path[,, max(dim(f_path)[3])], ncol=2)
f_mvar <- 5
f_proj <- data.frame(tourr::rescale(f_dat %*% f_bas))

# view_basis(f_bas, labels = colnames(f_dat)) +
#   geom_point(data = f_proj,
#              mapping = aes(x = X1 - 1.75, y = X2 - .5, color = f_cat),
#              pch = as.integer(f_cat) + 15)

f_ang <- .35
f_mt <- manual_tour(basis = f_bas,manip_var = f_mvar,angle = f_ang)

array2facet(.m_tour = f_mt, .data = f_dat, .m_var = f_mvar, .cat = f_cat)
