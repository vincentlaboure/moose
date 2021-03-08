#* This file is part of the MOOSE framework
#* https://www.mooseframework.org
#*
#* All rights reserved, see COPYRIGHT for full restrictions
#* https://github.com/idaholab/moose/blob/master/COPYRIGHT
#*
#* Licensed under LGPL 2.1, please see LICENSE for details
#* https://www.gnu.org/licenses/lgpl-2.1.html

import os
import collections
import mooseutils

@mooseutils.addProperty('name', ptype=str, required=True)
@mooseutils.addProperty('title', ptype=str, required=True)
@mooseutils.addProperty('filename', ptype=str)
class Document(mooseutils.AutoPropertyMixin):
    pass

INL_DOCUMENTS = ['safety_software_determination',
                 'quality_level_determination',
                 'enterprise_architecture_entry',
                 'project_management_plan', # deprecated
                 'software_quality_plan',
                 'configuration_management_plan',
                 'software_test_plan',
                 'asset_management_plan',
                 'verification_validation_plan',
                 'software_requirements_specification',
                 'software_design_description',
                 'requirements_traceablity_matrix',
                 'verification_validation_report',
                 'failure_analysis_report',
                 'user_manual',
                 'theory_manual']

def get_documents(required_docs=INL_DOCUMENTS, **kwargs):
    """
    Build SQA document dictionary from the provided directories.
    """
    return [Document(name=name, title=name.replace('_', ' ').title(), filename=kwargs.get(name, None)) for name in required_docs]
