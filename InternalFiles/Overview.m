%% Fluid Mechanics
% <html>
% <span style="font-family:Arial">
% <span style="font-size:12pt">
% <h2> Information </h2>
% This curriculum module contains interactive
% <a href="https://www.mathworks.com/products/matlab/live-editor.html">MATLAB&reg; live scripts</a>
% that teach fundamental concepts and basic terminology related to fluid
% mechanics. This includes discussions about the definition and
% descriptions of fluid (gas and liquid), the forces in actions in a fluid
% system at rest and in motion, integral and differential form of the
% conservation equation and in introduction to transport phenomenon. This
% content is broken into XXX instructional live scripts and one project
% where live script instructions are paired with a plain code practice
% script. Solutions are available upon instructors request.
% <br>
% <br>
% <a href=#module>Fluid Mechanics</a> covers
% <a href=#script1>textual</a> data, THEN COPY AS NEEDED. 
% Applications include BLAH, BLAH, and BLAH.
% <br>
% <br>
% You can use these live scripts as demonstrations in a lecture, class activities,
% or interactive assignments outside of class. The module is divided into
% DESCRIBE ORGANIZATION OF MODULE.
% <br>
% <br>
% The instructions inside the live scripts will guide you through the exercises and activities.
% Get started with each live script by running it one section at a time. To stop running the script
% or a section midway (for example, when an animation is in progress), use the <img src="../Images/end_24.png" height="16" style="vertical-align:top"> Stop button in the
% RUN section of the Live Editor tab in the MATLAB Toolstrip.
% <br>
% <br>
% If you find an issue or have a suggestion, email the MathWorks online teaching team at
% <a href="mailto:onlineteaching@mathworks.com">onlineteaching@mathworks.com</a>.
% <br>
% <br>
% <h2> Prerequisites </h2>
% This module assumes familiarity with advanced mathematical concept tought
% in Calculus I, II and III and familiarity with differential equations and
% differential calculus; mechanical concept such as statics and dynamics.
% These scripts assume some level of familiarity with MATLAB programming
% that could be aquired in <a href="https://www.mathworks.com/learn/tutorials/matlab-onramp.html">MATLAB
% Onramp</a>.
% <br>
% <br>
% <h2> Getting Started </h2>
% <ol>
%     <li>
%         Make sure that you have all the required products (listed below)
%         installed.
%     </li>
%         <li>
%             Get started with each topic by clicking the link in the first column of the table below to access the
%             full script example. The instructions inside each live script will walk
%             you through the live scripts and related functions.
%         </li>
% </ol>
% <h2> Products </h2>
%     MATLAB&reg; is used throughout.
% <br>
% <br>
% <h2>Scripts </h2>
% <table border=1 style="margin-left:20px; cellpadding:15px;">
%     <caption><h3>Organization of the Fluid Mechanics Module</h3></caption>
%     <tr>
%         <th scope="col">Topic
%         </th>
%         <th scope="col">In this script, students will...
%         </th>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit fluidDefinition.mlx;"><b>fluidDefinition.mlx</b> 
%              <br>
%             <img src = "./Images/waterDrop.jpg" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Classification of fluid flow. </li>
%                 <li> Common physical quantity.
%                 <li> Two points of view: Eulerian and Lagrangian. </li>
%                 <li> Material derivative. </li>
%                 <li> Reynolds transport theorem. </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit fluidDynamics.mlx;"><b>fluidDynamics.mlx</b> 
%              <br>
%              <img src = "./Images/windTurbine.jpg" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Conservation of mass. </li>
%                 <li> Conservation of momentum. </li>
%                 <li> Control Volume Method. </li>
%                 <li> Application to wind turbine. </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit ManOnTheMoon.mlx;"><b>ManOnTheMoon.mlx</b> 
%              <br>
%             <img src = "./Images/Apollo11Track.png" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Fluid dynamic in accelaration frame. </li>
%                 <li> Comparison with real data from Apollo 11. </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit InternalFlow.mlx;"><b>Internal Flow.mlx</b> 
%              <br>
%             <img src = "./Images/IMAGE_NAME.gif" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Bernoulli equation. </li>
%                 <li> Friction coefficient. </li>
%                 <li> Hydraulic head-loss. </li>
%             </ul>
%         </td>
%     </tr>
%     <tr>
%         <th scope="row">
%             <a name="script1"; href="matlab:edit differentialForms.mlx;"><b>differentialForms.mlx</b> 
%              <br>
%             <img src = "./Images/IMAGE_NAME.gif" width=150 style="margin-top:5px; margin-bottom:0px">
%             </a>
%         </th>              
%         <td>
%             <ul style="margin-top:5px; margin-bottom:10px">
%                 <li> Euler equation. </li>
%                 <li> Navier-Stokes Equations. </li>
%                 <li> Boundary-Layer theory. </li>
%             </ul>
%         </td>
%     </tr>
% </table>
% <br>
% <br>
% <h2>Learing points</h2>
%   <ul style="margin-top:5px; margin-bottom:10px">
%       <li> Understanding of material derivative (and so Eulerian specification of flow). </li>
%       <li> How to derive conservation equations (mass, momentum and energy) </li>
%       <li> Effect of gravity on fluid... Bouyancy only exist because of gravity! </li>
%       <li> Three methods for fluid dynamics problem: </li>
%           <ul style="margin-top:5px; margin-bottom:10px">
%               <li> differential form (Euler & Navier-Stokes) aka. I need to fully characterize the flow.</li>
%               <li> control volume method aka. I am ready to make some assumption</li>
%               <li> Bernoulli aka. particular type of problem</li>
%           </ul>
%       <li> Other? </li>
%   </ul>
% <br>
% <br>
% <h2> Additional Files </h2>
% <ul>
%   <li>XXX</li>
%   <li>XXX</li>
% </ul>
% </span>
% </span>
% </html>
% 
% Copyright 2022 The MathWorks(TM), Inc.
