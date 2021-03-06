library(Seurat)
library(dplyr)
library(ggplot2)

## subsetting seurat 4.0
tail(combined[[]])
Idents(object = combined) <- 'orig.ident'
Idents(object = combined)

### subset graph
library(ggplot2)
VlnPlot(object = subset(combined, idents = "liverABCC4KO", subset = seurat_clusters == "0" | seurat_clusters ==  "5" | seurat_clusters == "11" , slot ="data"), 
        features = 'Epcam',  group.by = "seurat_clusters",split.by = "orig.ident",pt.size=0.1)+scale_fill_manual(values = cols25())


table<-subset(combined, idents = "liverABCC4KO", subset = seurat_clusters == "0" | seurat_clusters ==  "5" | seurat_clusters == "11")@assays[["RNA"]]@counts

meta<-subset(combined, idents = "liverABCC4KO", subset = seurat_clusters == "0" | seurat_clusters ==  "5" | seurat_clusters == "11")[[]]

write.table(table, file='sub_count.tsv', quote=FALSE, sep='\t', col.names = TRUE)
write.table(meta, file='sub_pheno.tsv', quote=FALSE, sep='\t', col.names = TRUE)

## downsampling
table<-as.matrix(table)
tmat_sub<-t(table)
tmat_sub<-as.data.frame(tmat_sub)

ident_sub<-as.data.frame(meta)
### merge count and identities
all<-merge(ident_sub,tmat_sub,by="row.names")


df <- all %>% sample_n(1316)
head(df[1:5,1:10])
table(df$integrated_snn_res.0.2)

row.names(df)<-df$Row.names
data<-df[,8:ncol(df)]
tmat<-t(data)

smallmeta<-df[,1:7]
dim(smallmeta)

write.table(tmat, file='sample_count.tsv', quote=FALSE, sep='\t', col.names = TRUE)
write.table(smallmeta, file='sample_pheno.tsv', quote=FALSE, sep='\t', col.names = TRUE)
