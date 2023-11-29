my @sub = glob("subset*");
for my $sub (@sub) {
    system "vcftools --vcf Rchap.passfilter.recode.vcf --out $sub.Rchap --positions $sub --recode";
  }
