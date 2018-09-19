
<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
?>
<!DOCTYPE html>


<div id="content-wrapper">
    <form action="#">
        <div class="page-header">
            <h1><span class="text-light-gray">Form components / </span>Tambah IP Address</h1>
        </div> <!-- / .page-header -->

        <div class="row">
            <div class="col-sm-12">

                <!-- 5. $CONTROLS ==================================================================================
                
                                                Controls
                -->
                <div class="panel">
                    <div class="panel-heading">
                        <span class="panel-title">Controls</span>
                    </div>
                    <table class="table" id="inputs-table">
                        <thead>
                        <th>DATA</th>
                        <th>VALUE</th>

                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    Ip_Address
                                </td>
                                <td>
                                    <input type="text" class="form-control" placeholder="nama_aset">
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    Nama Domain
                                </td>
                                <td>
                                    <input type="text" class="form-control" placeholder="nama_aset">
                                </td>

                            </tr>
                            <tr>
                                <td>
                                    Jenis Akses 
                                </td>
                                <td>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" id="inlineCheckbox1" value="option1" class="px"> <span class="lbl">Publik</span>
                                    </label>
                                    <label class="checkbox-inline">
                                        <input type="checkbox" id="inlineCheckbox2" value="option2" checked="" class="px"> <span class="lbl">Lokal</span>
                                    </label>
                                   
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Status
                                </td>
                                <td>
                                    <div class="radio" style="margin-top: 0;">
                                        <label>
                                            <input type="radio" name="optionsRadios" id="optionsRadios1" value="Terlihat" checked="" class="px">
                                            <span class="lbl">Aktif</span>
                                        </label>
                                    </div> <!-- / .radio -->
                                    <div class="radio" style="margin-bottom: 0;">
                                        <label>
                                            <input type="radio" name="optionsRadios" id="optionsRadios2" value="Sembunyi" class="px">
                                            <span class="lbl">Tidak Aktif</span>
                                        </label>
                                    </div> <!-- / .radio -->
                                </td>

                            </tr>

                            <tr>
                                <td>
                                    Catatan
                                </td>
                                <td>
                                    <textarea class="form-control" rows="3"></textarea>
                                </td>

                            </tr>
                            <tr>
                                <td>
                                Arsip
                                </td>
                                <td>
                                    <script>
                                        init.push(function() {
                                            $("#dropzonejs-example").dropzone({
                                                url: "//dummy.html",
                                                paramName: "file", // The name that will be used to transfer the file
                                                maxFilesize: 0.5, // MB

                                                addRemoveLinks: true,
                                                dictResponseError: "Can't upload file!",
                                                autoProcessQueue: false,
                                                thumbnailWidth: 80,
                                                thumbnailHeight: 80,
                                                previewTemplate: '<div class="dz-preview dz-file-preview"><div class="dz-details"><div class="dz-filename"><span data-dz-name></span></div><div class="dz-size">File size: <span data-dz-size></span></div><div class="dz-thumbnail-wrapper"><div class="dz-thumbnail"><img data-dz-thumbnail><span class="dz-nopreview">No preview</span><div class="dz-success-mark"><i class="fa fa-check-circle-o"></i></div><div class="dz-error-mark"><i class="fa fa-times-circle-o"></i></div><div class="dz-error-message"><span data-dz-errormessage></span></div></div></div></div><div class="progress progress-striped active"><div class="progress-bar progress-bar-success" data-dz-uploadprogress></div></div></div>',
                                                resize: function(file) {
                                                    var info = {srcX: 0, srcY: 0, srcWidth: file.width, srcHeight: file.height},
                                                    srcRatio = file.width / file.height;
                                                    if (file.height > this.options.thumbnailHeight || file.width > this.options.thumbnailWidth) {
                                                        info.trgHeight = this.options.thumbnailHeight;
                                                        info.trgWidth = info.trgHeight * srcRatio;
                                                        if (info.trgWidth > this.options.thumbnailWidth) {
                                                            info.trgWidth = this.options.thumbnailWidth;
                                                            info.trgHeight = info.trgWidth / srcRatio;
                                                        }
                                                    } else {
                                                        info.trgHeight = file.height;
                                                        info.trgWidth = file.width;
                                                    }
                                                    return info;
                                                }
                                            });
                                        });
                                    </script>
                                    <div id="dropzonejs-example" class="dropzone-box">
                                        <div class="dz-default dz-message">
                                            <i class="fa fa-cloud-upload"></i>
                                            Drop files in here<br><span class="dz-text-small">or click to pick manually</span>
                                        </div>
                                        <form action="http://dummy.html/">
                                            <div class="fallback">
                                                <input name="file" type="file" multiple="" />
                                            </div>
                                        </form>
                                    </div>
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    Penanggung Jawab
                                </td>
                                <td>
                                    <select class="form-control form-group-margin">
                                        <option>Budi</option>
                                        <option>Anduk</option>
                                        <option>Kiwil</option>
                                        <option>Jambrong</option>
                                        <option>dll</option>
                                    </select>
                                </td>
                            </tr>
                            </tr>

                            <tr>
                                <td>
                                    Satuan Kerja
                                </td>
                                <td>
                                    <select class="form-control form-group-margin">
                                        <option>PDSI</option>
                                        <option>Balitbang</option>
                                        <option>SDPPI</option>
                                        <option>Aptika</option>
                                        <option>dll</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- /5. $CONTROLS -->

            </div>
        </div>
        
                <!-- /6. $HEIGHT_SIZING -->



            </div>
        </div>
        <div class="panel-footer text-right">
            <button class="btn btn-primary">Submit</button>
        </div>
    </form>
</div> <!-- / #content-wrapper -->

</body>

<!-- Mirrored from infinite-woodland-5276.herokuapp.com/forms-layouts.html by HTTrack Website Copier/3.x [XR&CO'2014], Wed, 01 Jul 2015 04:14:06 GMT -->
</html>
