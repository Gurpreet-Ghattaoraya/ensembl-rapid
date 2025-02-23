=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute
Copyright [2016-2022] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Document::HTML::WhatsNew;

use strict;

use base qw(EnsEMBL::Web::Document::HTML);

sub render {
  my $self  = shift;

  my $html = qq(<h2 class="box-header">Latest Genomes</h2>);
  my $limit = 25;

  ## TODO - replace this with list from metadata db
  my $info        = $self->hub->get_species_info;
  my $new_species = $self->hub->species_defs->multi_val('NEW_SPECIES') || [];
  my $total       = scalar @$new_species;
  my $lookup      = $self->hub->species_defs->prodnames_to_urls_lookup;

  if ($total > 0) {
    my $including = $total > 25 ? ', including' : '';
    my $word      = 'genome';
    $word .= 's' if $total > 1; 
    $html .= qq(<p>We have $total new $word this release$including:</p><ul>);

    my $count = 0;
    foreach my $prod_name (sort @$new_species) {
      last if $count == $limit;
      my $species = $lookup->{$prod_name};
      my $display_name  = $info->{$species}{'display_name'};
      $html .= sprintf '<li><a href="/%s/">%s</a></li>',
                $species, 
                $display_name;

      $count++;
    }

    $html .= '</ul>';

    if ($total > $limit) {
      $html .= '<p><a href="/info/about/species.html">More genomes</a></p>';
    }
    else {
      $html .= '<p><a href="/info/about/species.html">View all species and download data</a></p>';
    }
  }
  else {
    $html .= qq(<p>There are no new genomes this release. <a href="/info/about/species.html">View all species and download data</a></p>);
  }
  return $html;
}

1;
