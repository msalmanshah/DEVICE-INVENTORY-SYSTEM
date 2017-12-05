.col-md-8
  .panel.with-nav-tabs.panel-default
    .panel-heading.clearfix
      .pull-left
        //
          <h1 class="panel-title top10"><small><strong>&nbsp&nbspAHLI&nbsp&nbsp&nbsp</strong></small>011 AHMAD</h1>
        h6.panel-title.top10
          strong &nbsp&nbsp{{main.selectedsno}}
      .pull-right
        ul.nav.nav-tabs
          li.active
            a(href='#t2p1', data-toggle='tab')
              small
                strong KEAHLIAN
          li
            a(href='#t2p2', data-toggle='tab')
              small
                strong KELUARGA
          li
            a(href='#t2p3', data-toggle='tab')
              small
                strong YURAN
          li
            a(href='#t2p4', data-toggle='tab')
              small
                strong KHAIRAT
    .panel-body
      div
        .row
          .col-md-2
            statinfo
              strong
                small.text-info NO AHLI
              br
              |                                                 0111
          .col-md-2
            statinfo
              strong
                small.text-info NO KP
              br
              |                                                 711110-05-5999
          .col-md-2
            statinfo
              strong
                small.text-info NO TEL
              br
              |                                                 012 2112111
          .col-md-4
            statinfo
              strong
                small.text-info EMEL
              br
              |                                                 admad@disanadis.ini 12
          .col-md-2
            button.btn.btn-success.pull-right(type='submit')
              | Edit
              span.glyphicon.glyphicon-edit(aria-hidden='true')
        .row
          .col-md-12
            statinfo
              strong
                small.text-info NAMA
              br
              |                                                 AHMAD BIN ABU 123456789012345678901234567890123456789012345678901234567890 1234567
        .row
          .col-md-12
            statinfo
              strong
                small.text-info ALAMAT
              br
              |                                                 NO 3 LORONG NALURI SUKMA 8/11
        hr
    .tab-content
      #t2p1.tab-pane.fade.in.active
        .row
          .col-md-12
            .col-md-8
              statinfo
                strong
                  small.text-info KEAHLIAN
            .col-md-4.pull-right
              .col-md-6
                button.btn.btn-info.pull-right.disabled(type='submit')
                  | Daftar Semula
                  span.glyphicon.glyphicon-repeat(aria-hidden='true')
              .col-md-6
                button.btn.btn-danger.pull-right.disabled(type='submit')
                  | Batal Keahlian
                  span.glyphicon.glyphicon-remove(aria-hidden='true')
        .row
          .col-md-12
            .col-md-12
              include main.ahli.an.jade
      // ..................................................
      #t2p2.tab-pane.fade
        .row
          .col-md-12
            .col-md-8
              statinfo
                strong
                  small.text-info KELUARGA
            .col-md-4.pull-right
              .col-md-6
                button.btn.btn-info.pull-right.disabled(type='submit')
                  | Tambah Keluarga
                  span.glyphicon.glyphicon-plus(aria-hidden='true')
              .col-md-6
                button.btn.btn-danger.pull-right.disabled(type='submit')
                  | Tukar Status
                  span.glyphicon.glyphicon-remove(aria-hidden='true')
        .row
          .col-md-12
            .col-md-12
              table.table.table-condensed.table-striped(style='margin-top=20px')
                thead
                  tr
                    th.text-muted
                      small NAMA
                    th.text-muted
                      small HUBUNGAN
                    th.text-muted
                      small NO KP
                    th.text-muted
                      small UMUR
                    th.text-muted
                      small STATUS
                tbody
                  tr
                    td FATIMAH BINTI MOHAMAD
                    td ISTERI
                    td 771111-05-6008
                    td 39
                    td LAYAK
                  tr
                    td ABU BIN AHMAD
                    td ANAK
                    td 120101-05-3109
                    td 4
                    td LAYAK
                  tr
                    td ALI BIN AHMAD
                    td ANAK
                    td 970101-05-6009
                    td 29
                    td KELUAR SKIM
                  tr
                    td FATIMAH BINTI ABDULLAH
                    td IBUBAPA
                    td 571111-05-6008
                    td 69
                    td LAYAK
                  tr
                    td ABU BIN ALI
                    td IBUBAPA
                    td 500801-05-6095
                    td MENINGGAL
                    td MENINGGAL
      // ..................................................
      #t2p3.tab-pane.fade
        .row
          .col-md-12
            .col-md-8
              statinfo
                strong
                  small.text-info RESIT BAYARAN YURAN
            .col-md-4.pull-right
              .col-md-6
                button.btn.btn-info.pull-right.disabled(type='submit')
                  | Tambah Resit 
                  span.glyphicon.glyphicon-plus(aria-hidden='true')
        .row
          .col-md-12
            .col-md-12
              table.table.table-condensed.table-striped(style='margin-top=20px')
                thead
                  tr
                    th.text-muted
                      small NO RESIT
                    th.text-muted
                      small TARIKH
                    th.text-muted
                      small JENIS BAYARAN
                    th.text-muted
                      small AMAUN
                tbody
                  tr
                    th 1234
                    td 20/11/2013
                    td YURAN KEAHLIAN
                    td 50.00
                  tr
                    th 5678
                    td 11/02/2014
                    td YURAN TAHUNAN
                    td 20.00
                  tr
                    th 5678
                    td 11/02/2015
                    td YURAN TAHUNAN
                    td 20.00
                  tr
                    th 5678
                    td 11/02/2016
                    td YURAN TAHUNAN
                    td 20.00
      // ..................................................
      #t2p4.tab-pane.fade
        .row
          .col-md-12
            .col-md-8
              statinfo
                strong
                  small.text-info BAYARAN KHAIRAT
            .col-md-4.pull-right
              .col-md-12
                button.btn.btn-info.pull-right.disabled(type='submit')
                  | Tambah Bayaran 
                  span.glyphicon.glyphicon-plus(aria-hidden='true')
        .row
          .col-md-12
            .col-md-12
              table.table.table-condensed.table-striped(style='margin-top=20px')
                thead
                  tr
                    th.text-muted
                      small NO BAUCER
                    th.text-muted
                      small TARIKH
                    th.text-muted
                      small KHAIRAT UNTUK
                    th.text-muted
                      small AMAUN
                tbody
                  tr
                    th 0001
                    td 2/11/2014
                    td ABU BIN ALI - IBUBAPA
                    td 200.00

      // ..................................................
      #t1p5.tab-pane.fade Danger 5