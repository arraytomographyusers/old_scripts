function [srcFiles,row,loop] = overlapping(srcFiles,CurrentChannel,number_channels,x,R,channels,srcPath,row,loop,neuropilmask)

num_canals = length (CurrentChannel);
abc = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA','AB','AC','AD','AE','AF','AG','AH','AI','AJ','AK','AL','AM','AN','AO','AP','AQ','AR','AS','AT','AU','AV','AW','AX','AY','AZ','BA','BB','BC','BD','BE','BF','BG','BH','BI','BJ','BK','BL','BM','BN','BO','BP','BQ','BR','BS','BT','BU','BV','BW','BX','BY','BZ','CA','CB','CC','CD','CE','CF','CG','CH','CI','CJ','CK','CL','CM','CN','CO','CP','CQ','CR','CS','CT','CU','CV','CW','CX','CY','CZ','DA','DB','DC','DD','DE','DF','DG','DH','DI','DJ','DK','DL','DM','DN','DO','DP','DQ','DR','DS','DT','DU','DV','DW','DX','DY','DZ','EA','EB','EC','ED','EE','EF','EG','EH','EI','EJ','EK','EL','EM','EN','EO','EP','EQ','ER','ES','ET','EU','EV','EW','EX','EY','EZ','FA','FB','FC','FD','FE','FF','FG','FH','FI','FJ','FK','FL','FM','FN','FO','FP','FQ','FR','FS','FT','FU','FV','FW','FX','FY','FZ','GA','GB','GC','GD','GE','GF','GG','GH','GI','GJ','GK','GL','GM','GN','GO','GP','GQ','GR','GS','GT','GU','GV','GW','GX','GY','GZ','HA','HB','HC','HD','HE','HF','HG','HH','HI','HJ','HK','HL','HM','HN','HO','HP','HQ','HR','HS','HT','HU','HV','HW','HX','HY','HZ','IA','IB','IC','ID','IE','IF','IG','IH','II','IJ','IK','IL','IM','IN','IO','IP','IQ','IR','IS','IT','IU','IV','IW','IX','IY','IZ','JA','JB','JC','JD','JE','JF','JG','JH','JI','JJ','JK','JL','JM','JN','JO','JP','JQ','JR','JS','JT','JU','JV','JW','JX','JY','JZ','KA','KB','KC','KD','KE','KF','KG','KH','KI','KJ','KK','KL','KM','KN','KO','KP','KQ','KR','KS','KT','KU','KV','KW','KX','KY','KZ','LA','LB','LC','LD','LE','LF','LG','LH','LI','LJ','LK','LL','LM','LN','LO','LP','LQ','LR','LS','LT','LU','LV','LW','LX','LY','LZ','MA','MB','MC','MD','ME','MF','MG','MH','MI','MJ','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NB','NC','ND','NE','NF','NG','NH','NI','NJ','NK','NL','NM','NN','NO','NP','NQ','NR','NS','NT','NU','NV','NW','NX','NY','NZ','OA','OB','OC','OD','OE','OF','OG','OH','OI','OJ','OK','OL','OM','ON','OO','OP','OQ','OR','OS','OT','OU','OV','OW','OX','OY','OZ','PA','PB','PC','PD','PE','PF','PG','PH','PI','PJ','PK','PL','PM','PN','PO','PP','PQ','PR','PS','PT','PU','PV','PW','PX','PY','PZ','QA','QB','QC','QD','QE','QF','QG','QH','QI','QJ','QK','QL','QM','QN','QO','QP','QQ','QR','QS','QT','QU','QV','QW','QX','QY','QZ','RA','RB','RC','RD','RE','RF','RG','RH','RI','RJ','RK','RL','RM','RN','RO','RP','RQ','RR','RS','RT','RU','RV','RW','RX','RY','RZ','SA','SB','SC','SD','SE','SF','SG','SH','SI','SJ','SK','SL','SM','SN','SO','SP','SQ','SR','SS','ST','SU','SV','SW','SX','SY','SZ','TA','TB','TC','TD','TE','TF','TG','TH','TI','TJ','TK','TL','TM','TN','TO','TP','TQ','TR','TS','TT','TU','TV','TW','TX','TY','TZ','UA','UB','UC','UD','UE','UF','UG','UH','UI','UJ','UK','UL','UM','UN','UO','UP','UQ','UR','US','UT','UU','UV','UW','UX','UY','UZ','VA','VB','VC','VD','VE','VF','VG','VH','VI','VJ','VK','VL','VM','VN','VO','VP','VQ','VR','VS','VT','VU','VV','VW','VX','VY','VZ','WA','WB','WC','WD','WE','WF','WG','WH','WI','WJ','WK','WL','WM','WN','WO','WP','WQ','WR','WS','WT','WU','WV','WW','WX','WY','WZ','XA','XB','XC','XD','XE','XF','XG','XH','XI','XJ','XK','XL','XM','XN','XO','XP','XQ','XR','XS','XT','XU','XV','XW','XX','XY','XZ','YA','YB','YC','YD','YE','YF','YG','YH','YI','YJ','YK','YL','YM','YN','YO','YP','YQ','YR','YS','YT','YU','YV','YW','YX','YY','YZ','ZA','ZB','ZC','ZD','ZE','ZF','ZG','ZH','ZI','ZJ','ZK','ZL','ZM','ZN','ZO','ZP','ZQ','ZR','ZS','ZT','ZU','ZV','ZW','ZX','ZY','ZZ','AAA','AAB','AAC','AAD','AAE','AAF','AAG','AAH','AAI','AAJ','AAK','AAL','AAM','AAN','AAO','AAP','AAQ','AAR','AAS','AAT','AAU','AAV','AAW','AAX','AAY','AAZ','ABA','ABB','ABC','ABD','ABE','ABF','ABG','ABH','ABI','ABJ','ABK','ABL','ABM','ABN','ABO','ABP','ABQ','ABR','ABS','ABT','ABU','ABV','ABW','ABX','ABY','ABZ','ACA','ACB','ACC','ACD','ACE','ACF','ACG','ACH','ACI','ACJ','ACK','ACL','ACM','ACN','ACO','ACP','ACQ','ACR','ACS','ACT','ACU','ACV','ACW','ACX','ACY','ACZ','ADA','ADB','ADC','ADD','ADE','ADF','ADG','ADH','ADI','ADJ','ADK','ADL','ADM','ADN','ADO','ADP','ADQ','ADR','ADS','ADT','ADU','ADV','ADW','ADX','ADY','ADZ','AEA','AEB','AEC','AED','AEE','AEF','AEG','AEH','AEI','AEJ','AEK','AEL','AEM','AEN','AEO','AEP','AEQ','AER','AES','AET','AEU','AEV','AEW','AEX','AEY','AEZ','AFA','AFB','AFC','AFD','AFE','AFF','AFG','AFH','AFI','AFJ','AFK','AFL','AFM','AFN','AFO','AFP','AFQ','AFR','AFS','AFT','AFU','AFV','AFW','AFX','AFY','AFZ','AGA','AGB','AGC','AGD','AGE','AGF','AGG','AGH','AGI','AGJ','AGK','AGL','AGM','AGN','AGO','AGP','AGQ','AGR','AGS','AGT','AGU','AGV','AGW','AGX','AGY','AGZ','AHA','AHB','AHC','AHD','AHE','AHF','AHG','AHH','AHI','AHJ','AHK','AHL','AHM','AHN','AHO','AHP','AHQ','AHR','AHS','AHT','AHU','AHV','AHW','AHX','AHY','AHZ','AIA','AIB','AIC','AID','AIE','AIF','AIG','AIH','AII','AIJ','AIK','AIL','AIM','AIN','AIO','AIP','AIQ','AIR','AIS','AIT','AIU','AIV','AIW','AIX','AIY','AIZ','AJA','AJB','AJC','AJD','AJE','AJF','AJG','AJH','AJI','AJJ','AJK','AJL','AJM','AJN','AJO','AJP','AJQ','AJR','AJS','AJT','AJU','AJV','AJW','AJX','AJY','AJZ','AKA','AKB','AKC','AKD','AKE','AKF','AKG','AKH','AKI','AKJ','AKK','AKL','AKM','AKN','AKO','AKP','AKQ','AKR','AKS','AKT','AKU','AKV','AKW','AKX','AKY','AKZ','ALA','ALB','ALC','ALD','ALE','ALF','ALG','ALH','ALI','ALJ','ALK','ALL','ALM','ALN','ALO','ALP','ALQ','ALR','ALS','ALT','ALU','ALV','ALW','ALX','ALY','ALZ','AMA','AMB','AMC','AMD','AME','AMF','AMG','AMH','AMI','AMJ','AMK','AML','AMM','AMN','AMO','AMP','AMQ','AMR','AMS','AMT','AMU','AMV','AMW','AMX','AMY','AMZ','ANA','ANB','ANC','AND','ANE','ANF','ANG','ANH','ANI','ANJ','ANK','ANL','ANM','ANN','ANO','ANP','ANQ','ANR','ANS','ANT','ANU','ANV','ANW','ANX','ANY','ANZ','AOA','AOB','AOC','AOD','AOE','AOF','AOG','AOH','AOI','AOJ','AOK','AOL','AOM','AON','AOO','AOP','AOQ','AOR','AOS','AOT','AOU','AOV','AOW','AOX','AOY','AOZ','APA','APB','APC','APD','APE','APF','APG','APH','API','APJ','APK','APL','APM','APN','APO','APP','APQ','APR','APS','APT','APU','APV','APW','APX','APY','APZ','AQA','AQB','AQC','AQD','AQE','AQF','AQG','AQH','AQI','AQJ','AQK','AQL','AQM','AQN','AQO','AQP','AQQ','AQR','AQS','AQT','AQU','AQV','AQW','AQX','AQY','AQZ','ARA','ARB','ARC','ARD','ARE','ARF','ARG','ARH','ARI','ARJ','ARK','ARL','ARM','ARN','ARO','ARP','ARQ','ARR','ARS','ART','ARU','ARV','ARW','ARX','ARY','ARZ','ASA','ASB','ASC','ASD','ASE','ASF','ASG','ASH','ASI','ASJ','ASK','ASL','ASM','ASN','ASO','ASP','ASQ','ASR','ASS','AST','ASU','ASV','ASW','ASX','ASY','ASZ','ATA','ATB','ATC','ATD','ATE','ATF','ATG','ATH','ATI','ATJ','ATK','ATL','ATM','ATN','ATO','ATP','ATQ','ATR','ATS','ATT','ATU','ATV','ATW','ATX','ATY','ATZ','AUA','AUB','AUC','AUD','AUE','AUF','AUG','AUH','AUI','AUJ','AUK','AUL','AUM','AUN','AUO','AUP','AUQ','AUR','AUS','AUT','AUU','AUV','AUW','AUX','AUY','AUZ','AVA','AVB','AVC','AVD','AVE','AVF','AVG','AVH','AVI','AVJ','AVK','AVL','AVM','AVN','AVO','AVP','AVQ','AVR','AVS','AVT','AVU','AVV','AVW','AVX','AVY','AVZ','AWA','AWB','AWC','AWD','AWE','AWF','AWG','AWH','AWI','AWJ','AWK','AWL','AWM','AWN','AWO','AWP','AWQ','AWR','AWS','AWT','AWU','AWV','AWW','AWX','AWY','AWZ','AXA','AXB','AXC','AXD','AXE','AXF','AXG','AXH','AXI','AXJ','AXK','AXL','AXM','AXN','AXO','AXP','AXQ','AXR','AXS','AXT','AXU','AXV','AXW','AXX','AXY','AXZ','AYA','AYB','AYC','AYD','AYE','AYF','AYG','AYH','AYI','AYJ','AYK','AYL','AYM','AYN','AYO','AYP','AYQ','AYR','AYS','AYT','AYU','AYV','AYW','AYX','AYY','AYZ','AZA','AZB','AZC','AZD','AZE','AZF','AZG','AZH','AZI','AZJ','AZK','AZL','AZM','AZN','AZO','AZP','AZQ','AZR','AZS','AZT','AZU','AZV','AZW','AZX','AZY','AZZ','BAA','BAB','BAC','BAD','BAE','BAF','BAG','BAH','BAI','BAJ','BAK','BAL','BAM','BAN','BAO','BAP','BAQ','BAR','BAS','BAT','BAU','BAV','BAW','BAX','BAY','BAZ','BBA','BBB','BBC','BBD','BBE','BBF','BBG','BBH','BBI','BBJ','BBK','BBL','BBM','BBN','BBO','BBP','BBQ','BBR','BBS','BBT','BBU','BBV','BBW','BBX','BBY','BBZ','BCA','BCB','BCC','BCD','BCE','BCF','BCG','BCH','BCI','BCJ','BCK','BCL','BCM','BCN','BCO','BCP','BCQ','BCR','BCS','BCT','BCU','BCV','BCW','BCX','BCY','BCZ','BDA','BDB','BDC','BDD','BDE','BDF','BDG','BDH','BDI','BDJ','BDK','BDL','BDM','BDN','BDO','BDP','BDQ','BDR','BDS','BDT','BDU','BDV','BDW','BDX','BDY','BDZ','BEA','BEB','BEC','BED','BEE','BEF','BEG','BEH','BEI','BEJ','BEK','BEL','BEM','BEN','BEO','BEP'};

H = {'Sequence name', '#Objects', 'Total area (vox)', 'Neuropil area (vox)', 'Median area objects'};
xlswrite(strcat(srcPath,'\Results\Stats.xls'),H,'Hoja1',strcat('A1'));

for i=1:num_canals
    for jj=1:x  
        if  strfind((srcFiles(jj).name),CurrentChannel(i).name)==1   %%%COMPROVAR QUE SERVEIXI PER ALGO    
            for ii=1:number_channels % mirem per cada canal (j) si l'imatge k es solapa amb un altre d'aquell canal   
                    fprintf('%s vs %s\n',srcFiles(jj).name,CurrentChannel(ii).name); 
                    if size(srcFiles(jj).BW) == size(CurrentChannel(ii).BW)
                        if ~strcmp(srcFiles(jj).name,CurrentChannel(ii).name)
                            overlap_pre = srcFiles(jj).BW.*CurrentChannel(ii).BW;
                            reconstruct(ii).BW = imreconstruct(logical(overlap_pre),srcFiles(jj).BW);
                            overlap(ii) = bwconncomp(reconstruct(ii).BW,6);
                            srcFiles(jj).Stats(ii) = overlap(ii).NumObjects*100/srcFiles(jj).CC.NumObjects;
                            srcFiles(jj).isprocessed = 1;
                            Area = struct2array(regionprops(overlap(ii),'Area'));
                            srcFiles(jj).Aoverlap(ii) = median(Area); 
                            A = struct2array(regionprops(srcFiles(jj).BW,'Area'));
                            if R == 1
                                [randomized(ii).overlap, randomized(ii).obj_size] = randomize(srcFiles(jj),CurrentChannel(ii),neuropilmask);
                                sorted = sort(randomized(ii).overlap,'descend');
                                srcFiles(jj).med_coloc(ii) = median(sorted);
                                sorted2 = sort(randomized(ii).obj_size,'descend');
                                srcFiles(jj).med_objsize(ii) = median(sorted2);
                            end
                        else
                            srcFiles(jj).Stats(ii) = 100;
                            srcFiles(jj).med_coloc(ii) = 100;
                            overlap(ii) = bwconncomp(srcFiles(jj).BW,6);
                            A = struct2array(regionprops(srcFiles(jj).BW,'Area'));
                            srcFiles(jj).Aoverlap(ii) = median(A); 
                            srcFiles(jj).med_objsize(ii) = median(A);
                        end
                    else
                        srcFiles(jj).Stats(ii) = -1;
                        message= sprintf(strcat('Error dimension in: ',srcFiles(jj).name,' and: ',CurrentChannel(ii).name, '\n'));
                        uiwait(warndlg(message));
                    end
            end
             
            if number_channels == 3
                for ii=1:number_channels
                    k=ii+1;
                    k=mod(k,number_channels);
                    if k == 0
                        k=3;
                    end
                    if and(ii~=i,k~=i)   
                        fprintf(strcat('Overlapping: 3 channels\n')); 
                        overlap1en23 = reconstruct(ii).BW.*reconstruct(k).BW;
                        reconstruct1en23 = imreconstruct(logical(overlap1en23),srcFiles(jj).BW);

                        CC1en23 = bwconncomp(reconstruct1en23,6);
                        A3 = median(struct2array(regionprops(CC1en23,'Area')));
                        stats3 = CC1en23.NumObjects*100/srcFiles(jj).CC.NumObjects;
                        break;
                    end
                end
            end
            
            %%%% EXCEL EXPORT
            row=row+1;
            if row>252
                loop = loop + 1;
            end
            
            %%%% STATS
            [m,n,p] = size(srcFiles(jj).BW);
            num_vox = m*n*p;
            stats = num2cell(srcFiles(jj).Stats);  
            A2 = num2cell(srcFiles(jj).Aoverlap);

            S = {srcFiles(jj).name (srcFiles(jj).CC.NumObjects) num_vox (srcFiles(jj).areaneuropil) median(A)};
            xlswrite(strcat(srcPath,'\Results\Stats.xls'),S,'Hoja1',strcat('A',num2str(row+1)));

            if R == 1    
                median_coloc = num2cell(srcFiles(jj).med_coloc);
                A_Random = num2cell(srcFiles(jj).med_objsize);

                if number_channels == 1
                    head = {strcat('Median area w',channels{1})};
                    headers={channels{:} head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} A2{1:number_channels}};
                elseif number_channels == 2 
                    head = {strcat('Median area w',channels{1}) strcat('Median area w',channels{2}) strcat('Median area w',channels{1},'_R') strcat('Median area w',channels{2},'_R')};
                    headers={channels{:} strcat(channels{1},'_R') strcat(channels{2},'_R') head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} median_coloc{1:number_channels} A2{1:number_channels} A_Random{1:number_channels}};
                elseif number_channels == 3
                    head = {strcat('Median area w',channels{1}) strcat('Median area w',channels{2}) strcat('Median area w ',channels{3}) 'Median area w Other2' strcat('Median area w',channels{1},'_R') strcat('Median area w',channels{2},'_R') strcat('Median area w',channels{3},'_R')};
                    headers={channels{:} 'other2' strcat(channels{1},'_R') strcat(channels{2},'_R') strcat(channels{3},'_R') head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} stats3 median_coloc{1:number_channels} A2{1:number_channels} A3 A_Random{1:number_channels}};
                end
                xlswrite(strcat(srcPath,'\Results\Stats.xls'),statsFeatures, 'Hoja2',strcat('A',num2str(row+1)));
                xlswrite(strcat(srcPath,'\Results\Stats.xls'),headers,'Hoja2','B1');  
            else
                if number_channels == 1
                    head = {strcat('Median area w',channels{1})};
                    headers={channels{:} head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} A2{1:number_channels}};
                elseif number_channels == 2 
                    head = {strcat('Median area w',channels{1}) strcat('Median area w',channels{2})};
                    headers={channels{:} head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} A2{1:number_channels}};
                elseif number_channels == 3
                    head = {'other2' strcat('Median area w',channels{1}) strcat('Median area w',channels{2}) strcat('Median area w ',channels{3}) 'Median area w Other2'};
                    headers={channels{:} head{:}};
                    statsFeatures = {srcFiles(jj).name stats{1:number_channels} stats3 A2{1:number_channels} A3};
                end
                xlswrite(strcat(srcPath,'\Results\Stats.xls'),statsFeatures, 'Hoja2',strcat('A',num2str(row+1)));
                xlswrite(strcat(srcPath,'\Results\Stats.xls'),headers,'Hoja2','B1');    
            end
            
            %%%% OBJ SIZE
            for idx=1:srcFiles(jj).CC.NumObjects
                ObjSize.obj(idx)=length(srcFiles(jj).CC.PixelIdxList{idx});
            end  
            
            if srcFiles(jj).CC.NumObjects > 0
                Objects = {ObjSize.obj};
            else
                Objects = {0};
            end
            
            xlswrite(strcat(srcPath,'\Results\', 'ObjSize',num2str(loop),'.xls'),{srcFiles(jj).name},'Hoja1',strcat(abc{row},'1'));
            xlswrite(strcat(srcPath,'\Results\', 'ObjSize',num2str(loop),'.xls'),Objects{1,1}','Hoja1',strcat(abc{row},'2'));
            %%%% END EXCEL EXPORT
            
            %%% Delete BW image (too much heavy)and set obj empty
            srcFiles(jj).BW = [];
            ObjSize.obj = [];
        end
    end 
end
