do
    (x0, y0) <- mouse
    let (x, y) = quantise2 quantum (x0, y0)
    root <- currentPlane
    audio_id1  <-  new' "audio_id"
    audio_sin10  <-  new' "audio_sin"
    audio_sin2  <-  new' "audio_sin"
    audio_sin3  <-  new' "audio_sin"
    audio_sin4  <-  new' "audio_sin"
    audio_sin5  <-  new' "audio_sin"
    audio_sin6  <-  new' "audio_sin"
    audio_sin7  <-  new' "audio_sin"
    audio_sin8  <-  new' "audio_sin"
    audio_sin9  <-  new' "audio_sin"
    id11  <-  new' "id"
    id12  <-  new' "id"
    id13  <-  new' "id"
    id14  <-  new' "id"
    id15  <-  new' "id"
    id16  <-  new' "id"
    id17  <-  new' "id"
    id18  <-  new' "id"
    id19  <-  new' "id"
    id20  <-  new' "id"
    id21  <-  new' "id"
    id22  <-  new' "id"
    input36  <-  new' "input"
    input37  <-  new' "input"
    input38  <-  new' "input"
    input39  <-  new' "input"
    input40  <-  new' "input"
    input41  <-  new' "input"
    input42  <-  new' "input"
    input43  <-  new' "input"
    input44  <-  new' "input"
    input45  <-  new' "input"
    input46  <-  new' "input"
    input47  <-  new' "input"
    input48  <-  new' "input"
    input49  <-  new' "input"
    input51  <-  new' "input"
    input52  <-  new' "input"
    input53  <-  new' "input"
    input60  <-  new' "input"
    input61  <-  new' "input"
    sum468  <-  new' "sum4"
    sum469  <-  new' "sum4"
    sum470  <-  new' "sum4"
    sum471  <-  new' "sum4"
    sum65  <-  new' "sum"
    sum66  <-  new' "sum"
    sum67  <-  new' "sum"
    sum72  <-  new' "sum"
    sum73  <-  new' "sum"
    sum74  <-  new' "sum"
    sum75  <-  new' "sum"
    sum76  <-  new' "sum"
    sum77  <-  new' "sum"
    vca78  <-  new' "vca"
    vca79  <-  new' "vca"
    vca80  <-  new' "vca"
    vca81  <-  new' "vca"
    vca82  <-  new' "vca"
    vca83  <-  new' "vca"
    vca84  <-  new' "vca"
    vca85  <-  new' "vca"
    vca86  <-  new' "vca"
    vca87  <-  new' "vca"
    vca88  <-  new' "vca"
    vca89  <-  new' "vca"
    vca90  <-  new' "vca"
    vca91  <-  new' "vca"
    vca92  <-  new' "vca"
    vca93  <-  new' "vca"
    vca94  <-  new' "vca"
    vca95  <-  new' "vca"
    container156 <- container' "panel_organ.png" (x+(-2.0), y+(-1.0)) (Inside root)
    container157 <- container' "panel_3x1.png" (-288.0,192.0) (Inside container156)
    in158 <- plugin' (vca78 ! "cv") (-312.0,216.0) (Outside container157)
    setColour in158 "#control"
    in159 <- plugin' (vca78 ! "signal") (-312.0,168.0) (Outside container157)
    setColour in159 "#sample"
    label160 <- label' "vca" (-312.0,264.0) (Outside container157)
    out161 <- plugout' (vca78 ! "result") (-264.0,192.0) (Outside container157)
    setColour out161 "#sample"
    container162 <- container' "panel_3x1.png" (-288.0,-48.0) (Inside container156)
    in163 <- plugin' (vca79 ! "cv") (-309.0,-23.0) (Outside container162)
    setColour in163 "#control"
    in164 <- plugin' (vca79 ! "signal") (-309.0,-73.0) (Outside container162)
    setColour in164 "#sample"
    label165 <- label' "vca" (-313.0,27.0) (Outside container162)
    out166 <- plugout' (vca79 ! "result") (-268.0,-48.0) (Outside container162)
    setColour out166 "#sample"
    container167 <- container' "panel_3x1.png" (-288.0,-288.0) (Inside container156)
    in168 <- plugin' (vca80 ! "cv") (-309.0,-263.0) (Outside container167)
    setColour in168 "#control"
    in169 <- plugin' (vca80 ! "signal") (-309.0,-313.0) (Outside container167)
    setColour in169 "#sample"
    label170 <- label' "vca" (-313.0,-213.0) (Outside container167)
    out171 <- plugout' (vca80 ! "result") (-268.0,-288.0) (Outside container167)
    setColour out171 "#sample"
    container172 <- container' "panel_3x1.png" (-288.0,-528.0) (Inside container156)
    in173 <- plugin' (vca81 ! "cv") (-309.0,-503.0) (Outside container172)
    setColour in173 "#control"
    in174 <- plugin' (vca81 ! "signal") (-309.0,-553.0) (Outside container172)
    setColour in174 "#sample"
    label175 <- label' "vca" (-313.0,-453.0) (Outside container172)
    out176 <- plugout' (vca81 ! "result") (-268.0,-528.0) (Outside container172)
    setColour out176 "#sample"
    container177 <- container' "panel_3x1.png" (-288.0,-768.0) (Inside container156)
    in178 <- plugin' (vca82 ! "cv") (-309.0,-743.0) (Outside container177)
    setColour in178 "#control"
    in179 <- plugin' (vca82 ! "signal") (-309.0,-793.0) (Outside container177)
    setColour in179 "#sample"
    label180 <- label' "vca" (-313.0,-693.0) (Outside container177)
    out181 <- plugout' (vca82 ! "result") (-268.0,-768.0) (Outside container177)
    setColour out181 "#sample"
    container182 <- container' "panel_3x1.png" (-288.0,-1008.0) (Inside container156)
    in183 <- plugin' (vca83 ! "cv") (-309.0,-983.0) (Outside container182)
    setColour in183 "#control"
    in184 <- plugin' (vca83 ! "signal") (-309.0,-1033.0) (Outside container182)
    setColour in184 "#sample"
    label185 <- label' "vca" (-313.0,-933.0) (Outside container182)
    out186 <- plugout' (vca83 ! "result") (-268.0,-1008.0) (Outside container182)
    setColour out186 "#sample"
    container187 <- container' "panel_3x1.png" (-288.0,-1248.0) (Inside container156)
    in188 <- plugin' (vca84 ! "cv") (-309.0,-1223.0) (Outside container187)
    setColour in188 "#control"
    in189 <- plugin' (vca84 ! "signal") (-309.0,-1273.0) (Outside container187)
    setColour in189 "#sample"
    label190 <- label' "vca" (-313.0,-1173.0) (Outside container187)
    out191 <- plugout' (vca84 ! "result") (-268.0,-1248.0) (Outside container187)
    setColour out191 "#sample"
    container192 <- container' "panel_3x1.png" (-288.0,-1488.0) (Inside container156)
    in193 <- plugin' (vca85 ! "cv") (-309.0,-1463.0) (Outside container192)
    setColour in193 "#control"
    in194 <- plugin' (vca85 ! "signal") (-309.0,-1513.0) (Outside container192)
    setColour in194 "#sample"
    label195 <- label' "vca" (-313.0,-1413.0) (Outside container192)
    out196 <- plugout' (vca85 ! "result") (-268.0,-1488.0) (Outside container192)
    setColour out196 "#sample"
    container197 <- container' "panel_3x1.png" (-288.0,-1728.0) (Inside container156)
    in198 <- plugin' (vca86 ! "cv") (-309.0,-1703.0) (Outside container197)
    setColour in198 "#control"
    in199 <- plugin' (vca86 ! "signal") (-309.0,-1753.0) (Outside container197)
    setColour in199 "#sample"
    label200 <- label' "vca" (-313.0,-1653.0) (Outside container197)
    out201 <- plugout' (vca86 ! "result") (-268.0,-1728.0) (Outside container197)
    setColour out201 "#sample"
    container202 <- container' "panel_knob.png" (-672.0,-564.0) (Inside container156)
    in203 <- plugin' (id21 ! "signal") (-684.0,-564.0) (Outside container202)
    setColour in203 "#control"
    hide in203
    knob204 <- knob' (input44 ! "result") (-684.0,-564.0) (Outside container202)
    out205 <- plugout' (id21 ! "result") (-648.0,-564.0) (Outside container202)
    setColour out205 "#control"
    container206 <- container' "panel_3x1.png" (-624.0,-792.0) (Inside container156)
    in207 <- plugin' (id22 ! "signal") (-645.0,-792.0) (Outside container206)
    setColour in207 "#control"
    label208 <- label' "id" (-649.0,-717.0) (Outside container206)
    out209 <- plugout' (id22 ! "result") (-604.0,-792.0) (Outside container206)
    setColour out209 "#control"
    container210 <- container' "panel_4x1.png" (274.0,-653.0) (Inside container156)
    container211 <- container' "panel_4x1.png" (392.0,-335.0) (Inside container156)
    container212 <- container' "panel_3x1.png" (-137.0,-763.0) (Inside container156)
    container213 <- container' "panel_3x1.png" (-56.0,-42.0) (Inside container156)
    container214 <- container' "panel_3x1.png" (-137.0,-43.0) (Inside container156)
    container215 <- container' "panel_3x1.png" (-56.0,-1722.0) (Inside container156)
    container216 <- container' "panel_3x1.png" (24.0,-1724.0) (Inside container156)
    container217 <- container' "panel_3x1.png" (-137.0,-1723.0) (Inside container156)
    container218 <- container' "panel_3x1.png" (-137.0,197.0) (Inside container156)
    container219 <- container' "panel_3x1.png" (24.0,196.0) (Inside container156)
    container220 <- container' "panel_3x1.png" (-56.0,-522.0) (Inside container156)
    container221 <- container' "panel_3x1.png" (24.0,-524.0) (Inside container156)
    container222 <- container' "panel_3x1.png" (-137.0,-523.0) (Inside container156)
    container223 <- container' "panel_3x1.png" (24.0,-284.0) (Inside container156)
    container224 <- container' "panel_3x1.png" (-56.0,-282.0) (Inside container156)
    container225 <- container' "panel_3x1.png" (-137.0,-283.0) (Inside container156)
    container226 <- container' "panel_3x1.png" (-56.0,198.0) (Inside container156)
    container227 <- container' "panel_3x1.png" (-137.0,-1243.0) (Inside container156)
    container228 <- container' "panel_3x1.png" (-56.0,-1242.0) (Inside container156)
    container229 <- container' "panel_3x1.png" (24.0,-1244.0) (Inside container156)
    container230 <- container' "panel_3x1.png" (24.0,-44.0) (Inside container156)
    container231 <- container' "panel_3x1.png" (-137.0,-1483.0) (Inside container156)
    container232 <- container' "panel_3x1.png" (24.0,-1484.0) (Inside container156)
    container233 <- container' "panel_3x1.png" (-56.0,-1482.0) (Inside container156)
    container234 <- container' "panel_3x1.png" (-56.0,-1002.0) (Inside container156)
    container235 <- container' "panel_3x1.png" (24.0,-1004.0) (Inside container156)
    container236 <- container' "panel_3x1.png" (-137.0,-1003.0) (Inside container156)
    container237 <- container' "panel_3x1.png" (24.0,-764.0) (Inside container156)
    container238 <- container' "panel_3x1.png" (-56.0,-762.0) (Inside container156)
    container239 <- container' "panel_4x1.png" (274.0,-22.0) (Inside container156)
    container240 <- container' "panel_4x1.png" (277.0,-326.0) (Inside container156)
    in241 <- plugin' (sum470 ! "signal4") (253.0,-728.0) (Inside container156)
    setColour in241 "#sample"
    in242 <- plugin' (sum471 ! "signal1") (371.0,-260.0) (Inside container156)
    setColour in242 "#sample"
    in243 <- plugin' (sum471 ! "signal2") (371.0,-310.0) (Inside container156)
    setColour in243 "#sample"
    in244 <- plugin' (sum471 ! "signal3") (371.0,-360.0) (Inside container156)
    setColour in244 "#sample"
    in245 <- plugin' (sum471 ! "signal4") (371.0,-410.0) (Inside container156)
    setColour in245 "#sample"
    in246 <- plugin' (sum73 ! "signal1") (-158.0,-738.0) (Inside container156)
    setColour in246 "#sample"
    in247 <- plugin' (sum73 ! "signal2") (-158.0,-788.0) (Inside container156)
    setColour in247 "#sample"
    in248 <- plugin' (audio_sin6 ! "freq") (-77.0,-17.0) (Inside container156)
    setColour in248 "#control"
    in249 <- plugin' (audio_sin6 ! "sync") (-77.0,-67.0) (Inside container156)
    setColour in249 "#sample"
    in250 <- plugin' (sum72 ! "signal1") (-158.0,-18.0) (Inside container156)
    setColour in250 "#sample"
    in251 <- plugin' (sum72 ! "signal2") (-158.0,-68.0) (Inside container156)
    setColour in251 "#sample"
    in252 <- plugin' (audio_sin3 ! "freq") (-77.0,-1697.0) (Inside container156)
    setColour in252 "#control"
    in253 <- plugin' (audio_sin3 ! "sync") (-77.0,-1747.0) (Inside container156)
    setColour in253 "#sample"
    in254 <- plugin' (vca95 ! "cv") (3.0,-1699.0) (Inside container156)
    setColour in254 "#control"
    in255 <- plugin' (vca95 ! "signal") (3.0,-1749.0) (Inside container156)
    setColour in255 "#sample"
    in256 <- plugin' (sum77 ! "signal2") (-158.0,-1748.0) (Inside container156)
    setColour in256 "#sample"
    in257 <- plugin' (sum77 ! "signal1") (-158.0,-1698.0) (Inside container156)
    setColour in257 "#sample"
    in258 <- plugin' (audio_id1 ! "signal") (465.0,-335.0) (Inside container156)
    setColour in258 "#sample"
    in259 <- plugin' (sum65 ! "signal1") (-158.0,222.0) (Inside container156)
    setColour in259 "#sample"
    in260 <- plugin' (sum65 ! "signal2") (-158.0,172.0) (Inside container156)
    setColour in260 "#sample"
    in261 <- plugin' (vca89 ! "cv") (3.0,221.0) (Inside container156)
    setColour in261 "#control"
    in262 <- plugin' (vca89 ! "signal") (3.0,171.0) (Inside container156)
    setColour in262 "#sample"
    in263 <- plugin' (audio_sin4 ! "freq") (-77.0,-497.0) (Inside container156)
    setColour in263 "#control"
    in264 <- plugin' (audio_sin4 ! "sync") (-77.0,-547.0) (Inside container156)
    setColour in264 "#sample"
    in265 <- plugin' (vca88 ! "cv") (3.0,-499.0) (Inside container156)
    setColour in265 "#control"
    in266 <- plugin' (vca88 ! "signal") (3.0,-549.0) (Inside container156)
    setColour in266 "#sample"
    in267 <- plugin' (sum67 ! "signal1") (-158.0,-498.0) (Inside container156)
    setColour in267 "#sample"
    in268 <- plugin' (sum67 ! "signal2") (-158.0,-548.0) (Inside container156)
    setColour in268 "#sample"
    in269 <- plugin' (vca87 ! "cv") (3.0,-259.0) (Inside container156)
    setColour in269 "#control"
    in270 <- plugin' (vca87 ! "signal") (3.0,-309.0) (Inside container156)
    setColour in270 "#sample"
    in271 <- plugin' (audio_sin5 ! "freq") (-77.0,-257.0) (Inside container156)
    setColour in271 "#control"
    in272 <- plugin' (audio_sin5 ! "sync") (-77.0,-307.0) (Inside container156)
    setColour in272 "#sample"
    in273 <- plugin' (sum66 ! "signal1") (-158.0,-258.0) (Inside container156)
    setColour in273 "#sample"
    in274 <- plugin' (sum66 ! "signal2") (-158.0,-308.0) (Inside container156)
    setColour in274 "#sample"
    in275 <- plugin' (audio_sin2 ! "freq") (-77.0,223.0) (Inside container156)
    setColour in275 "#control"
    in276 <- plugin' (audio_sin2 ! "sync") (-77.0,173.0) (Inside container156)
    setColour in276 "#sample"
    in277 <- plugin' (sum74 ! "signal1") (-158.0,-1218.0) (Inside container156)
    setColour in277 "#sample"
    in278 <- plugin' (sum74 ! "signal2") (-158.0,-1268.0) (Inside container156)
    setColour in278 "#sample"
    in279 <- plugin' (audio_sin8 ! "freq") (-77.0,-1217.0) (Inside container156)
    setColour in279 "#control"
    in280 <- plugin' (audio_sin8 ! "sync") (-77.0,-1267.0) (Inside container156)
    setColour in280 "#sample"
    in281 <- plugin' (vca91 ! "cv") (3.0,-1219.0) (Inside container156)
    setColour in281 "#control"
    in282 <- plugin' (vca91 ! "signal") (3.0,-1269.0) (Inside container156)
    setColour in282 "#sample"
    in283 <- plugin' (vca90 ! "cv") (3.0,-19.0) (Inside container156)
    setColour in283 "#control"
    in284 <- plugin' (vca90 ! "signal") (3.0,-69.0) (Inside container156)
    setColour in284 "#sample"
    in285 <- plugin' (sum75 ! "signal1") (-158.0,-1458.0) (Inside container156)
    setColour in285 "#sample"
    in286 <- plugin' (sum75 ! "signal2") (-158.0,-1508.0) (Inside container156)
    setColour in286 "#sample"
    in287 <- plugin' (vca92 ! "cv") (3.0,-1459.0) (Inside container156)
    setColour in287 "#control"
    in288 <- plugin' (vca92 ! "signal") (3.0,-1509.0) (Inside container156)
    setColour in288 "#sample"
    in289 <- plugin' (audio_sin7 ! "freq") (-77.0,-1457.0) (Inside container156)
    setColour in289 "#control"
    in290 <- plugin' (audio_sin7 ! "sync") (-77.0,-1507.0) (Inside container156)
    setColour in290 "#sample"
    in291 <- plugin' (audio_sin9 ! "freq") (-77.0,-977.0) (Inside container156)
    setColour in291 "#control"
    in292 <- plugin' (audio_sin9 ! "sync") (-77.0,-1027.0) (Inside container156)
    setColour in292 "#sample"
    in293 <- plugin' (vca94 ! "cv") (3.0,-979.0) (Inside container156)
    setColour in293 "#control"
    in294 <- plugin' (vca94 ! "signal") (3.0,-1029.0) (Inside container156)
    setColour in294 "#sample"
    in295 <- plugin' (sum76 ! "signal1") (-158.0,-978.0) (Inside container156)
    setColour in295 "#sample"
    in296 <- plugin' (sum76 ! "signal2") (-158.0,-1028.0) (Inside container156)
    setColour in296 "#sample"
    in297 <- plugin' (vca93 ! "cv") (3.0,-739.0) (Inside container156)
    setColour in297 "#control"
    in298 <- plugin' (vca93 ! "signal") (3.0,-789.0) (Inside container156)
    setColour in298 "#sample"
    in299 <- plugin' (audio_sin10 ! "freq") (-77.0,-737.0) (Inside container156)
    setColour in299 "#control"
    in300 <- plugin' (audio_sin10 ! "sync") (-77.0,-787.0) (Inside container156)
    setColour in300 "#sample"
    in301 <- plugin' (sum468 ! "signal1") (253.0,53.0) (Inside container156)
    setColour in301 "#sample"
    in302 <- plugin' (sum468 ! "signal2") (253.0,3.0) (Inside container156)
    setColour in302 "#sample"
    in303 <- plugin' (sum468 ! "signal3") (253.0,-47.0) (Inside container156)
    setColour in303 "#sample"
    in304 <- plugin' (sum468 ! "signal4") (253.0,-97.0) (Inside container156)
    setColour in304 "#sample"
    in305 <- plugin' (sum469 ! "signal1") (256.0,-251.0) (Inside container156)
    setColour in305 "#sample"
    in306 <- plugin' (sum469 ! "signal2") (256.0,-301.0) (Inside container156)
    setColour in306 "#sample"
    in307 <- plugin' (sum469 ! "signal3") (256.0,-351.0) (Inside container156)
    setColour in307 "#sample"
    in308 <- plugin' (sum469 ! "signal4") (256.0,-401.0) (Inside container156)
    setColour in308 "#sample"
    in309 <- plugin' (sum470 ! "signal1") (253.0,-578.0) (Inside container156)
    setColour in309 "#sample"
    in310 <- plugin' (sum470 ! "signal2") (253.0,-628.0) (Inside container156)
    setColour in310 "#sample"
    in311 <- plugin' (sum470 ! "signal3") (253.0,-678.0) (Inside container156)
    setColour in311 "#sample"
    knob312 <- knob' (input46 ! "result") (-302.0,-788.0) (Inside container156)
    knob313 <- knob' (input41 ! "result") (-314.0,-80.0) (Inside container156)
    knob314 <- knob' (input47 ! "result") (-314.0,-1748.0) (Inside container156)
    knob315 <- knob' (input48 ! "result") (-312.0,168.0) (Inside container156)
    knob316 <- knob' (input39 ! "result") (-314.0,-548.0) (Inside container156)
    knob317 <- knob' (input40 ! "result") (-314.0,-308.0) (Inside container156)
    knob318 <- knob' (input43 ! "result") (-314.0,-1268.0) (Inside container156)
    knob319 <- knob' (input42 ! "result") (-314.0,-1520.0) (Inside container156)
    knob320 <- knob' (input45 ! "result") (-314.0,-1040.0) (Inside container156)
    label321 <- label' "sum4" (249.0,53.0) (Inside container156)
    label322 <- label' "sum4" (252.0,-251.0) (Inside container156)
    label323 <- label' "sum4" (249.0,-578.0) (Inside container156)
    label324 <- label' "sum4" (367.0,-260.0) (Inside container156)
    label325 <- label' "sum" (-162.0,-688.0) (Inside container156)
    label326 <- label' "audio_sin" (-81.0,33.0) (Inside container156)
    label327 <- label' "sum" (-162.0,32.0) (Inside container156)
    label328 <- label' "audio_sin" (-81.0,-1647.0) (Inside container156)
    label329 <- label' "vca" (-1.0,-1649.0) (Inside container156)
    label330 <- label' "sum" (-162.0,-1648.0) (Inside container156)
    label331 <- label' "sum" (-162.0,272.0) (Inside container156)
    label332 <- label' "vca" (-1.0,271.0) (Inside container156)
    label333 <- label' "audio_sin" (-81.0,-447.0) (Inside container156)
    label334 <- label' "vca" (-1.0,-449.0) (Inside container156)
    label335 <- label' "sum" (-162.0,-448.0) (Inside container156)
    label336 <- label' "vca" (-1.0,-209.0) (Inside container156)
    label337 <- label' "audio_sin" (-81.0,-207.0) (Inside container156)
    label338 <- label' "sum" (-162.0,-208.0) (Inside container156)
    label339 <- label' "audio_sin" (-81.0,273.0) (Inside container156)
    label340 <- label' "sum" (-162.0,-1168.0) (Inside container156)
    label341 <- label' "audio_sin" (-81.0,-1167.0) (Inside container156)
    label342 <- label' "vca" (-1.0,-1169.0) (Inside container156)
    label343 <- label' "vca" (-1.0,31.0) (Inside container156)
    label344 <- label' "sum" (-162.0,-1408.0) (Inside container156)
    label345 <- label' "vca" (-1.0,-1409.0) (Inside container156)
    label346 <- label' "audio_sin" (-81.0,-1407.0) (Inside container156)
    label347 <- label' "audio_sin" (-81.0,-927.0) (Inside container156)
    label348 <- label' "vca" (-1.0,-929.0) (Inside container156)
    label349 <- label' "sum" (-162.0,-928.0) (Inside container156)
    label350 <- label' "vca" (-1.0,-689.0) (Inside container156)
    label351 <- label' "audio_sin" (-81.0,-687.0) (Inside container156)
    out352 <- plugout' (sum469 ! "result") (297.0,-326.0) (Inside container156)
    setColour out352 "#sample"
    out353 <- plugout' (sum470 ! "result") (294.0,-653.0) (Inside container156)
    setColour out353 "#sample"
    out354 <- plugout' (sum471 ! "result") (412.0,-335.0) (Inside container156)
    setColour out354 "#sample"
    out355 <- plugout' (sum73 ! "result") (-117.0,-763.0) (Inside container156)
    setColour out355 "#sample"
    out356 <- plugout' (audio_sin6 ! "result") (-36.0,-42.0) (Inside container156)
    setColour out356 "#sample"
    out357 <- plugout' (sum72 ! "result") (-117.0,-43.0) (Inside container156)
    setColour out357 "#sample"
    out358 <- plugout' (audio_sin3 ! "result") (-36.0,-1722.0) (Inside container156)
    setColour out358 "#sample"
    out359 <- plugout' (vca95 ! "result") (44.0,-1724.0) (Inside container156)
    setColour out359 "#sample"
    out360 <- plugout' (sum77 ! "result") (-117.0,-1723.0) (Inside container156)
    setColour out360 "#sample"
    out361 <- plugout' (id14 ! "result") (-191.0,-677.0) (Inside container156)
    setColour out361 "#control"
    out362 <- plugout' (id11 ! "result") (-191.0,43.0) (Inside container156)
    setColour out362 "#control"
    out363 <- plugout' (id16 ! "result") (-191.0,-1637.0) (Inside container156)
    setColour out363 "#control"
    out364 <- plugout' (id17 ! "result") (-515.0,-989.0) (Inside container156)
    setColour out364 "#control"
    out365 <- plugout' (id19 ! "result") (-191.0,-437.0) (Inside container156)
    setColour out365 "#control"
    out366 <- plugout' (id18 ! "result") (-191.0,-197.0) (Inside container156)
    setColour out366 "#control"
    out367 <- plugout' (id20 ! "result") (-191.0,283.0) (Inside container156)
    setColour out367 "#control"
    out368 <- plugout' (id12 ! "result") (-191.0,-1157.0) (Inside container156)
    setColour out368 "#control"
    out369 <- plugout' (id13 ! "result") (-191.0,-1397.0) (Inside container156)
    setColour out369 "#control"
    out370 <- plugout' (id15 ! "result") (-191.0,-917.0) (Inside container156)
    setColour out370 "#control"
    out371 <- plugout' (sum65 ! "result") (-117.0,197.0) (Inside container156)
    setColour out371 "#sample"
    out372 <- plugout' (vca89 ! "result") (44.0,196.0) (Inside container156)
    setColour out372 "#sample"
    out373 <- plugout' (audio_sin4 ! "result") (-36.0,-522.0) (Inside container156)
    setColour out373 "#sample"
    out374 <- plugout' (vca88 ! "result") (44.0,-524.0) (Inside container156)
    setColour out374 "#sample"
    out375 <- plugout' (sum67 ! "result") (-117.0,-523.0) (Inside container156)
    setColour out375 "#sample"
    out376 <- plugout' (vca87 ! "result") (44.0,-284.0) (Inside container156)
    setColour out376 "#sample"
    out377 <- plugout' (audio_sin5 ! "result") (-36.0,-282.0) (Inside container156)
    setColour out377 "#sample"
    out378 <- plugout' (sum66 ! "result") (-117.0,-283.0) (Inside container156)
    setColour out378 "#sample"
    out379 <- plugout' (audio_sin2 ! "result") (-36.0,198.0) (Inside container156)
    setColour out379 "#sample"
    out380 <- plugout' (sum74 ! "result") (-117.0,-1243.0) (Inside container156)
    setColour out380 "#sample"
    out381 <- plugout' (audio_sin8 ! "result") (-36.0,-1242.0) (Inside container156)
    setColour out381 "#sample"
    out382 <- plugout' (vca91 ! "result") (44.0,-1244.0) (Inside container156)
    setColour out382 "#sample"
    out383 <- plugout' (vca90 ! "result") (44.0,-44.0) (Inside container156)
    setColour out383 "#sample"
    out384 <- plugout' (sum75 ! "result") (-117.0,-1483.0) (Inside container156)
    setColour out384 "#sample"
    out385 <- plugout' (vca92 ! "result") (44.0,-1484.0) (Inside container156)
    setColour out385 "#sample"
    out386 <- plugout' (audio_sin7 ! "result") (-36.0,-1482.0) (Inside container156)
    setColour out386 "#sample"
    out387 <- plugout' (audio_sin9 ! "result") (-36.0,-1002.0) (Inside container156)
    setColour out387 "#sample"
    out388 <- plugout' (vca94 ! "result") (44.0,-1004.0) (Inside container156)
    setColour out388 "#sample"
    out389 <- plugout' (sum76 ! "result") (-117.0,-1003.0) (Inside container156)
    setColour out389 "#sample"
    out390 <- plugout' (vca93 ! "result") (44.0,-764.0) (Inside container156)
    setColour out390 "#sample"
    out391 <- plugout' (audio_sin10 ! "result") (-36.0,-762.0) (Inside container156)
    setColour out391 "#sample"
    out392 <- plugout' (sum468 ! "result") (294.0,-22.0) (Inside container156)
    setColour out392 "#sample"
    in393 <- plugin' (id19 ! "signal") (x+(-48.0), y+(0.0)) (Outside container156)
    setColour in393 "#control"
    hide in393
    in394 <- plugin' (id18 ! "signal") (x+(48.0), y+(60.0)) (Outside container156)
    setColour in394 "#control"
    hide in394
    in395 <- plugin' (id20 ! "signal") (x+(-48.0), y+(60.0)) (Outside container156)
    setColour in395 "#control"
    hide in395
    in396 <- plugin' (id11 ! "signal") (x+(0.0), y+(60.0)) (Outside container156)
    setColour in396 "#control"
    hide in396
    in397 <- plugin' (id12 ! "signal") (x+(-48.0), y+(-60.0)) (Outside container156)
    setColour in397 "#control"
    hide in397
    in398 <- plugin' (id13 ! "signal") (x+(0.0), y+(-60.0)) (Outside container156)
    setColour in398 "#control"
    hide in398
    in399 <- plugin' (id15 ! "signal") (x+(48.0), y+(0.0)) (Outside container156)
    setColour in399 "#control"
    hide in399
    in400 <- plugin' (id14 ! "signal") (x+(0.0), y+(0.0)) (Outside container156)
    setColour in400 "#control"
    hide in400
    in401 <- plugin' (id16 ! "signal") (x+(48.0), y+(-60.0)) (Outside container156)
    setColour in401 "#control"
    hide in401
    in402 <- plugin' (id17 ! "signal") (x+(-60.0), y+(120.0)) (Outside container156)
    setColour in402 "#control"
    knob403 <- knob' (input51 ! "result") (x+(-48.0), y+(60.0)) (Outside container156)
    knob404 <- knob' (input52 ! "result") (x+(0.0), y+(60.0)) (Outside container156)
    knob405 <- knob' (input38 ! "result") (x+(48.0), y+(60.0)) (Outside container156)
    knob406 <- knob' (input49 ! "result") (x+(-48.0), y+(0.0)) (Outside container156)
    knob407 <- knob' (input61 ! "result") (x+(0.0), y+(0.0)) (Outside container156)
    knob408 <- knob' (input36 ! "result") (x+(48.0), y+(0.0)) (Outside container156)
    knob409 <- knob' (input53 ! "result") (x+(-48.0), y+(-60.0)) (Outside container156)
    knob410 <- knob' (input60 ! "result") (x+(0.0), y+(-60.0)) (Outside container156)
    knob411 <- knob' (input37 ! "result") (x+(48.0), y+(-60.0)) (Outside container156)
    out412 <- plugout' (audio_id1 ! "result") (x+(60.0), y+(-120.0)) (Outside container156)
    setColour out412 "#sample"
    cable out209 in158
    cable knob315 in159
    cable out209 in163
    cable knob313 in164
    cable out209 in168
    cable knob317 in169
    cable out209 in173
    cable knob316 in174
    cable out209 in178
    cable knob312 in179
    cable out209 in183
    cable knob320 in184
    cable out209 in188
    cable knob318 in189
    cable out209 in193
    cable knob319 in194
    cable out209 in198
    cable knob314 in199
    cable knob204 in203
    cable out205 in207
    cable out392 in242
    cable out352 in243
    cable out353 in244
    cable out364 in246
    cable out181 in247
    cable out357 in248
    cable out364 in250
    cable out166 in251
    cable out360 in252
    cable out363 in254
    cable out358 in255
    cable out201 in256
    cable out364 in257
    cable out354 in258
    cable out364 in259
    cable out161 in260
    cable out367 in261
    cable out379 in262
    cable out375 in263
    cable out365 in265
    cable out373 in266
    cable out364 in267
    cable out176 in268
    cable out366 in269
    cable out377 in270
    cable out378 in271
    cable out364 in273
    cable out171 in274
    cable out371 in275
    cable out364 in277
    cable out191 in278
    cable out380 in279
    cable out368 in281
    cable out381 in282
    cable out362 in283
    cable out356 in284
    cable out364 in285
    cable out196 in286
    cable out369 in287
    cable out386 in288
    cable out384 in289
    cable out389 in291
    cable out370 in293
    cable out387 in294
    cable out364 in295
    cable out186 in296
    cable out361 in297
    cable out391 in298
    cable out355 in299
    cable out372 in301
    cable out383 in302
    cable out376 in303
    cable out374 in305
    cable out390 in306
    cable out388 in307
    cable out382 in309
    cable out385 in310
    cable out359 in311
    cable knob406 in393
    cable knob405 in394
    cable knob403 in395
    cable knob404 in396
    cable knob409 in397
    cable knob410 in398
    cable knob408 in399
    cable knob407 in400
    cable knob411 in401
    recompile
    set knob204 (1.0)
    set knob312 (0.15833333)
    set knob313 (0.0)
    set knob314 (0.3)
    set knob315 (-0.1)
    set knob316 (0.1)
    set knob317 (5.8333334e-2)
    set knob318 (0.23333333)
    set knob319 (0.25833333)
    set knob320 (0.2)
    set knob403 (0.0)
    set knob404 (0.5)
    set knob405 (0.5)
    set knob406 (0.0)
    set knob407 (0.0)
    set knob408 (5.9402987e-2)
    set knob409 (0.0)
    set knob410 (0.0)
    set knob411 (3.0e-2)
    return ()
