# MIKK_GeneNetwork

Repository for code relating to the submission of MIKK genotypes and phenotypes to GeneNetwork.org.

## Code to transfer clean VCF to GeneNetwork Dropbox using `rclone`

```
rclone copy \
  /nfs/research/birney/users/ian/MIKK_GeneNetwork/vcfs/mikk_clean.vcf.gz \
  GeneNetworkDropbox:MIKK_Medaka_Inbred_Kiyosu-Karlsruhe_Panel/
```
